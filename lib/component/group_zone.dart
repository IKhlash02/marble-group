import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:marble_group/config.dart';

class GroupZone extends RectangleComponent {
  final Color color;
  final int index;

  late final Color _originalPaintColor;

  GroupZone({
    required super.position,
    required this.color,
    required this.index,
    required super.size,
  }) : super(paint: Paint()..color = color) {
    _originalPaintColor = paint.color;
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }


  void markCorrect(bool isCorrect) {
    paint.color = isCorrect
        ? _originalPaintColor
        : AppColors.accentRed;
  }

  void revertColor() {
    paint.color = _originalPaintColor;
  }


  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final borderPaint = Paint()
      ..color = Color.lerp(color, Colors.black, 0.3)!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(10));
    canvas.drawRRect(rrect, paint);
    canvas.drawRRect(rrect, borderPaint);
  }
}
