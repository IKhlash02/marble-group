import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marble_group/ui/widget/pixel_style.dart';
import '../../utils/config.dart';
import '../../model/overlay_type.dart';

class PixelAction extends StatelessWidget {
  const PixelAction({super.key, required this.type});
  final OverlayType type;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case OverlayType.welcome:
        return _buildStartAction();
      case OverlayType.correct:
        return _buildStars();
      case OverlayType.wrong:
        return _buildTryAgain();
    }
  }

  Widget _buildStartAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: pixelBoxDecoration(AppColors.buttonBackground, 8.0, 4, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _arrow(),
          Text('TAP TO START', style: pixelTextStyle(fontSize: 16, letterSpacing: 1.0, fontWeight: FontWeight.w900).copyWith(color: Colors.green[800])),
          _arrow(),
        ],
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(duration: 1.5.seconds, begin: const Offset(1, 1), end: const Offset(1.08, 1.08))
        .then()
        .scale(duration: 1.5.seconds, begin: const Offset(1.08, 1.08), end: const Offset(1, 1));
  }

  Widget _arrow() {
    return Container(
      width: 16,
      height: 16,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: pixelBoxDecoration(AppColors.textLight, 2.0, 1, 2),
      child: Icon(Icons.play_arrow, size: 12, color: AppColors.buttonBackground),
    );
  }

  Widget _buildStars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(zoneColors.length, (i) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 24,
          height: 24,
          decoration: pixelBoxDecoration(zoneColors[i], 4.0, 2, 3),
          child: Icon(Icons.star, size: 16, color: AppColors.textLight),
        )
            .animate(delay: (i * 150).ms)
            .scale(duration: 400.ms, curve: Curves.elasticOut)
            .then(delay: 500.ms)
            .shimmer(duration: 2.seconds, color: AppColors.textLight);
      }),
    );
  }

  Widget _buildTryAgain() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: pixelBoxDecoration(AppColors.accentRed, 8.0, 3, 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.refresh, size: 20, color: AppColors.textLight),
          const SizedBox(width: 8),
          Text('TRY AGAIN', style: pixelTextStyle(fontSize: 14, letterSpacing: 1.0)),
        ],
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .shake(hz: 2, rotation: 0.03);
  }
}
