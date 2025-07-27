

import 'package:flutter/material.dart';

extension ColorLightenExtension on Color {
  Color toLighter([double amount = 0.3]) {
    assert(amount >= 0 && amount <= 1);
    return Color.lerp(this, Colors.white, amount)!;
  }

  Color toDarker([double amount = 0.4]) {
    assert(amount >= 0 && amount <= 1);
    return Color.lerp(this, Colors.black, amount)!;
  }
}
