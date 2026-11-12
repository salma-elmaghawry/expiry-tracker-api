import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.r,
      height: size.r,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [AppColors.primary, AppColors.third],
        ),
        borderRadius: BorderRadius.circular(size.r * 0.28),
      ),
      child: Icon(
        Icons.event_available_rounded,
        size: size.r * 0.56,
        color: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }
}
