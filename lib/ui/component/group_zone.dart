import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:marble_group/utils/color_extension.dart';
import 'package:marble_group/utils/config.dart';

class GroupZone extends PositionComponent {
  final Color color;
  final int index;

  late final Paint _paint;

  GroupZone({
    required super.position,
    required this.color,
    required this.index,
    required super.size,
  }) : super(
         children: [RectangleHitbox()..collisionType = CollisionType.passive],
       );

  @override
  Future<void> onLoad() async {
    _paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
  }

  void markCorrect(bool isCorrect) {
    _paint.color = isCorrect ? color : AppColors.accentRed;
  }

  void revertColor() {
    _paint.color = color;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final currentColor = _paint.color;
    final shadowAndBorderColor = currentColor.toDarker(0.3);
    final shadowPaint = Paint()
      ..color = shadowAndBorderColor
      ..style = PaintingStyle.fill;

    final shadowOffset = Offset(5, 6);
    final shadowRect = RRect.fromRectAndRadius(
      (shadowOffset & size.toSize()),
      Radius.circular(zoneBorderRadius),
    );
    canvas.drawRRect(shadowRect, shadowPaint);

    final mainRect = RRect.fromRectAndRadius(
      (Offset.zero & size.toSize()),
      Radius.circular(zoneBorderRadius),
    );
    canvas.drawRRect(mainRect, _paint);


    final borderPaint = Paint()
      ..color = shadowAndBorderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(mainRect, borderPaint);
  }
}
