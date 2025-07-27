import 'dart:math' as math;

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
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

  Marble({required super.position})
    : super(
        radius: 15,
        paint: Paint()
          ..color = AppColors.cardBackground
          ..style = PaintingStyle.fill,
        children: [
          CircleComponent(
            radius: 15,
            paint: Paint()
              ..color = AppColors.cardBackground.toDarker(0.3)
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

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    if (other is GroupZone) {
      for (var m in _groupMembers) {
        m.applyZoneColor(other.color);
        m.zoneIndex = other.index;
      }
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
    }
  }

  void _handleGrouping(Marble other) {
    final gm = game.groupMap;
    final a = groupId, b = other.groupId;
    if (a == null && b == null) {
      final id = _nextGroupId++;
      gm[id] = {this, other};
      groupId = other.groupId = id;
    } else if (a == null && b != null) {
      gm[b]!.add(this);
      groupId = b;
    } else if (a != b && a != null && b != null) {
      final lower = math.min(a, b), higher = math.max(a, b);
      gm[lower]!.addAll(gm[higher]!);
      for (var m in gm[higher]!) {
        m.groupId = lower;
      }
      gm.remove(higher);
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
