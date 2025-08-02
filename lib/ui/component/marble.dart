import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';
import 'package:marble_group/utils/color_extension.dart';
import 'package:marble_group/utils/config.dart';

import 'group_zone.dart';
import 'marble_grouping_game.dart';

class Marble extends CircleComponent
    with
        HasGameReference<MarbleGroupingGame>,
        DragCallbacks,
        CollisionCallbacks {
  static int _nextGroupId = 0;
  int? groupId;
  int? zoneIndex;


  final _linePaint = Paint()
    ..color = Colors.grey[400]!
    ..strokeWidth = 1.5
    ..style = PaintingStyle.stroke;

  Marble({required super.position})
    : super(
        radius: 18,
        paint: Paint()
          ..color = AppColors.marbleBlue
          ..style = PaintingStyle.fill,
        children: [
          CircleComponent(
            radius: 18,
            paint: Paint()
              ..color = AppColors.marbleBlue.toDarker(0.3)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 4,
          ),
          CircleHitbox()..collisionType = CollisionType.active,
        ],
      );

  Set<Marble> get _groupMembers {
    if (groupId == null) return {this};
    return game.groupMap[groupId] ?? {this};
  }

  void applyZoneColor(Color base) {
    paint.color = base;
    for (final child in children.whereType<CircleComponent>()) {
      if (child.paint.style == PaintingStyle.stroke) {
        child.paint.color = base.toDarker(0.3);
      }
    }
  }

  void _applyGroupColor() {
    final members = _groupMembers;
    if (members.length < 2) {
      applyZoneColor(AppColors.marbleBlue);
      return;
    }

    final colorIndex = (members.length - 2).clamp(0, groupColors.length - 1);
    final newColor = groupColors[colorIndex];

    for (var m in members) {
      m.applyZoneColor(newColor);
    }
  }


  void _repositionGroup() {
    final members = _groupMembers.toList();
    if (members.length <= 1) return;

    if (zoneIndex == null) {
      _applyGroupColor();
    }

    final diameter = radius * 2;

    var centroid = Vector2.zero();
    for (final m in members) {
      centroid += m.position;
    }
    centroid /= members.length.toDouble();

    void addMoveEffect(Marble marble, Vector2 targetPosition) {
      marble.removeWhere((c) => c is MoveToEffect);
      marble.add(
        MoveToEffect(
          targetPosition,
          EffectController(duration: 0.3, curve: Curves.easeInOut),
        ),
      );
    }

    switch (members.length) {
      case 2:
        addMoveEffect(members[0], centroid + Vector2(-radius, 0));
        addMoveEffect(members[1], centroid + Vector2(radius, 0));
        break;
      case 3:
        final angleOffset = -math.pi / 2;
        final triangleRadius = diameter / (2 * math.sin(math.pi / 3));
        for (int i = 0; i < members.length; i++) {
          final angle = 2 * math.pi * i / 3 + angleOffset;
          final target = centroid +
              Vector2(
                triangleRadius * math.cos(angle),
                triangleRadius * math.sin(angle),
              );
          addMoveEffect(members[i], target);
        }
        break;
      case 4:
        final halfSpacing = radius;
        addMoveEffect(members[0], centroid + Vector2(-halfSpacing, -halfSpacing));
        addMoveEffect(members[1], centroid + Vector2(halfSpacing, -halfSpacing));
        addMoveEffect(members[2], centroid + Vector2(halfSpacing, halfSpacing));
        addMoveEffect(members[3], centroid + Vector2(-halfSpacing, halfSpacing));
        break;
      default:
        _formHexagonalCluster(members, centroid, diameter, addMoveEffect);
    }
  }

  void _formHexagonalCluster(List<Marble> members, Vector2 centroid, double diameter, void Function(Marble, Vector2) addMoveEffect) {
    addMoveEffect(members[0], centroid);

    int placedCount = 1;
    int layer = 1;

    while (placedCount < members.length) {
      final layerCapacity = 6 * layer;
      final marblesInThisLayer = math.min(layerCapacity, members.length - placedCount);

      final layerRadius = diameter * layer * (math.sqrt(3)/2);

      for (int i = 0; i < marblesInThisLayer; i++) {
        final angle = (2 * math.pi * i / marblesInThisLayer) + (math.pi / 6 * layer);

        final target = centroid + Vector2(
          layerRadius * math.cos(angle),
          layerRadius * math.sin(angle),
        );
        addMoveEffect(members[placedCount], target);
        placedCount++;
      }
      layer++;
    }
  }


  void repositionInZone(GroupZone zone){
    final members = _groupMembers.toList();
    if(members.isEmpty) return;

    final double spacingX = radius * 1.9;
    final double spacingY = radius * 1.9;
    const int maxRows = 2;

    final anchor = Vector2(
        zone.position.x + zone.size.x ,
        zone.position.y + zone.size.y / 2 - spacingY/2);


    for (int i = 0; i < members.length; i++) {
      final row = i % maxRows;
      final col = (i / maxRows).floor();

      final offsetY = (row == 0) ? -spacingY / 2 : spacingY / 2;

      final targetPosition = Vector2(
        anchor.x + col * spacingX,
        anchor.y + offsetY,
      );

      members[i].removeWhere((c) => c is MoveToEffect);
      members[i].add(
        MoveToEffect(
          targetPosition,
          EffectController(duration: 0.3, curve: Curves.linear),
        ),
      );
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if(groupId == null || zoneIndex != null)  return;


    for (final other in _groupMembers) {
        canvas.drawLine(
          Offset(radius, radius),
          (other.position - position + Vector2(radius, radius)).toOffset(),
          _linePaint,
        );

    }


  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is GroupZone) {

      for (var m in _groupMembers) {
        m.applyZoneColor(other.color);
        m.zoneIndex = other.index;
      }

      repositionInZone(other);
    }

    if (other is Marble) {

      _handleGrouping(other);
    }


  }

  @override
  void onCollisionEnd(PositionComponent other) {
    super.onCollisionEnd(other);

    if (other is GroupZone) {
      for (var m in _groupMembers) {
        m.applyZoneColor(AppColors.cardBackground);
        m.zoneIndex = null;
      }
      _repositionGroup();
    }
  }

  void _handleGrouping(Marble other) {
    final gm = game.groupMap;
    final a = groupId, b = other.groupId;

    bool needsReposition = false;

    if (a == null && b == null) {
      final id = _nextGroupId++;
      gm[id] = {this, other};
      groupId = other.groupId = id;
      needsReposition = true;
    } else if (a == null && b != null) {
      gm[b]!.add(this);
      groupId = b;
      needsReposition = true;
    } else if (a != b && a != null && b != null) {
      final lower = math.min(a, b), higher = math.max(a, b);
      gm[lower]!.addAll(gm[higher]!);
      for (var m in gm[higher]!) {
        m.groupId = lower;
      }
      gm.remove(higher);
      needsReposition = true;
    }

    if (needsReposition) {
      _repositionGroup();
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    final delta = event.localDelta;
    for (var m in _groupMembers) {
      m.position += delta;
    }
  }
}
