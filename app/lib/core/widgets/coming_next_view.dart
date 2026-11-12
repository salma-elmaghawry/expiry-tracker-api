import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ComingNextView extends StatelessWidget {
  final IconData icon;

  const ComingNextView({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 56.r,
              color: Theme.of(context).colorScheme.primary,
            ),
            verticalSpace(12),
            Text(
              'placeholder.coming_next'.tr(),
              style: AppTextStyles.font14Normal.secondary(context),
              textAlign: TextAlign.center,
            ),
          ],
        ).fadeInScale(),
      ),
    );
  }
}
