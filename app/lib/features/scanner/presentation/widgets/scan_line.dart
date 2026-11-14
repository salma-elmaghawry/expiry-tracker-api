import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// The green line that moves up and down inside the scan [frame].
/// Place it inside a [Stack].
class ScanLine extends StatelessWidget {
  final Rect frame;
  final double inset;

  const ScanLine({super.key, required this.frame, this.inset = 16});

  @override
  Widget build(BuildContext context) {
    final travel = frame.height / 2 - inset;

    return Positioned(
      left: frame.left + inset,
      width: frame.width - inset * 2,
      top: frame.center.dy - 1,
      child: IgnorePointer(
        child:
            Container(
                  height: 2,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryDark,
                    boxShadow: [
                      BoxShadow(color: AppColors.primaryDark, blurRadius: 12),
                    ],
                  ),
                )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .moveY(
                  begin: -travel,
                  end: travel,
                  duration: 1600.ms,
                  curve: Curves.easeInOut,
                ),
      ),
    );
  }
}
