import 'package:flutter/material.dart';
import 'package:marble_group/utils/color_extension.dart';
import '../../utils/config.dart';


BoxDecoration pixelBoxDecoration(Color baseColor, double circular, double dx, double dy) {
  return BoxDecoration(
    color: baseColor,
    borderRadius: BorderRadius.circular(circular),
    border: Border.all(color: baseColor.toDarker(), width: 3),
    boxShadow: [
      BoxShadow(color: baseColor.toDarker(), offset: Offset(dx, dy), blurRadius: 0),
    ],
  );
}

TextStyle pixelTextStyle({
  required double fontSize,
  FontWeight fontWeight = FontWeight.w900,
  double letterSpacing = 2.0,
}) {
  return TextStyle(
    color: AppColors.textLight,
    fontSize: fontSize,
    fontWeight: fontWeight,
    letterSpacing: letterSpacing,
    height: 1.2,
    shadows: const [
      Shadow(color: Colors.black, offset: Offset(1, 1), blurRadius: 0),
    ],
  );
}
