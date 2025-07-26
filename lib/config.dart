import 'dart:ui';

import 'package:flutter/material.dart';

final lightPastel = Color(0xffeba0f0);
final deepMagenta = Color(0xffb946af);

final zoneColors = [
  Colors.orange,
  Colors.yellow,
  Colors.cyan,
  Colors.green,
];



abstract class AppColors {
  // Background screen
  static const Color background       = Color(0xFFEB9EF3); // #EB9EF3

  static const Color headerBackground = Color(0xFFC273CF); // #C273CF

  // Kotak soal (24 ÷ 3)
  static const Color cardBackground   = Color(0xFF794CB1); // #794CB1

  // Tombol “Check Answer”
  static const Color buttonBackground = Color(0xFF82e2b4); // #6FD18D

  // Aksen kiri:
  static const Color accentOrange     = Color(0xFFE4A582); // #E4A582
  static const Color accentYellow     = Color(0xFFDCE47D); // #DCE47D
  static const Color accentCyan       = Color(0xFF7ADCE1); // #7ADCE1

  // Teks terang (angka, label)
  static const Color textLight        = Color(0xFFFFFFFF); // #FFFFFF
}
