import 'package:flutter/material.dart';

final zoneColors = [
  AppColors.accentOrange,
  AppColors.accentYellow,
  AppColors.accentCyan,
  AppColors.accentOrange,
  AppColors.accentYellow,
];

abstract class AppColors {
  static const Color background = Color(0xFFEB9EF3);
  static const Color headerBackground = Color(0xFFb74aaf);
  static const Color cardBackground = Color(0xFF794CB1);
  static const Color cardSmallBackground = Color(0xFF561f97);
  static const Color buttonBackground = Color(0xFF82e2b4);
  static const Color accentOrange = Color(0xFFE4A582);
  static const Color accentYellow = Color(0xFFDCE47D);
  static const Color accentCyan = Color(0xFF7ADCE1);
  static const Color accentRed = Color(0xFFE57C7C);
  static const Color textLight = Color(0xFFFFFFFF);
}

//Group Zone
const double zoneBorderRadius = 10.0;
const double kGameMargin = 25.0;
const double kGroupZoneSpacing = 45.0;
const double kGroupZoneWidth = 70.0;


//marble
const double kMinDistance = 50.0;

