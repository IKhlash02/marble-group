import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:marble_group/ui/widget/pixel_action.dart';
import 'package:marble_group/ui/widget/pixel_style.dart';
import 'package:marble_group/utils/color_extension.dart';
import 'package:marble_group/utils/overlay_extension.dart';

import '../model/overlay_type.dart';
import '../utils/config.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({
    super.key,
    required this.title,
    required this.subtitle,
    this.overlayType = OverlayType.welcome,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final OverlayType overlayType;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //     colors: [
        //       Colors.black.withOpacity(0.3),
        //       Colors.black.withOpacity(0.8),
        //       Colors.black.withOpacity(0.3),
        //     ],
        //   ),
        // ),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPixelBanner()
                  .animate()
                  .slideY(
                    duration: 800.ms,
                    begin: -3,
                    end: 0,
                    curve: Curves.bounceOut,
                  )
                  .fadeIn(duration: 600.ms),

              const SizedBox(height: 20),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: pixelBoxDecoration(
                  overlayType.baseColor,
                  12.0,
                  6,
                  8,
                ),
                child: Column(
                  children: [
                    _buildPixelIcon().animate().scale(
                      duration: 700.ms,
                      curve: Curves.elasticOut,
                      begin: const Offset(0, 0),
                      end: const Offset(1, 1),
                    ),

                    const SizedBox(height: 20),

                    Text(
                          title,
                          style: TextStyle(
                            height: 0.8,
                            color: AppColors.textLight,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 2.0,
                            shadows: [
                              Shadow(
                                color: Colors.black,
                                offset: const Offset(3, 3),
                                blurRadius: 0,
                              ),
                              Shadow(
                                color: Colors.black,
                                offset: const Offset(-1, -1),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        )
                        .animate()
                        .slideY(
                          duration: 600.ms,
                          begin: -1,
                          end: 0,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: 500.ms, delay: 200.ms),

                    const SizedBox(height: 16),

                    Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: pixelBoxDecoration(
                            overlayType.baseColor.toDarker(0.2),
                            8.0,
                            2,
                            3,
                          ),
                          child: Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textLight,
                              height: 1.2,
                              fontWeight: FontWeight.w700,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  offset: const Offset(1, 1),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                        .animate()
                        .slideY(
                          duration: 700.ms,
                          begin: 1,
                          end: 0,
                          curve: Curves.easeOutBack,
                        )
                        .fadeIn(duration: 600.ms, delay: 400.ms),

                    const SizedBox(height: 24),

                    // Action elements
                    PixelAction(type: overlayType)
                        .animate(delay: 800.ms)
                        .slideY(begin: 2, end: 0, duration: 500.ms)
                        .fadeIn(duration: 400.ms),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPixelBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: pixelBoxDecoration(AppColors.headerBackground, 8.0, 4, 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(
            3,
            (index) => Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(right: 8),
              decoration: pixelBoxDecoration(AppColors.accentYellow, 2.0, 1, 2),
            ),
          ),
          Text(
            'MATH GAME',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
              shadows: [
                Shadow(
                  color: Colors.black,
                  offset: const Offset(2, 2),
                  blurRadius: 0,
                ),
              ],
            ),
          ),
          ...List.generate(
            3,
            (index) => Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(left: 8),
              decoration: pixelBoxDecoration(AppColors.accentYellow, 2.0, 1, 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPixelIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: pixelBoxDecoration(overlayType.iconColor, 8.0, 4, 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: pixelBoxDecoration(
              overlayType.iconColor.toLighter(),
              4.0,
              2,
              3,
            ),
          ),
          Icon(
            overlayType.iconData,
            size: 40,
            color: AppColors.textLight,
            shadows: [
              Shadow(
                color: Colors.black,
                offset: const Offset(2, 2),
                blurRadius: 0,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
