
import 'package:flutter/material.dart';

import '../model/overlay_type.dart';
import 'config.dart';

extension OverlayTypeStyle on OverlayType {
  Color get baseColor {
    switch (this) {
      case OverlayType.welcome:
        return AppColors.cardBackground;
      case OverlayType.correct:
        return AppColors.buttonBackground;
      case OverlayType.wrong:
        return AppColors.accentRed;
    }
  }

  Color get iconColor {
    switch (this) {
      case OverlayType.welcome:
        return AppColors.accentCyan;
      case OverlayType.correct:
        return AppColors.accentYellow;
      case OverlayType.wrong:
        return AppColors.headerBackground;
    }
  }

  IconData get iconData {
    switch (this) {
      case OverlayType.welcome:
        return Icons.play_circle_fill;
      case OverlayType.correct:
        return Icons.check_circle;
      case OverlayType.wrong:
        return Icons.cancel;
    }
  }
}
