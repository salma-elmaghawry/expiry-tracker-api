import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StateView extends StatelessWidget {
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String? body;
  final double iconSize;
  final List<Widget> actions;

  const StateView({
    super.key,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    this.body,
    this.iconSize = 80,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconSize.r,
                height: iconSize.r,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: (iconSize * 0.45).r, color: iconColor),
              ),
              verticalSpace(14),
              Text(
                title,
                style: AppTextStyles.font20ExtraBold,
                textAlign: TextAlign.center,
              ),
              if (body != null) ...[
                verticalSpace(8),
                Text(
                  body!,
                  style: AppTextStyles.font15Medium.secondary(context),
                  textAlign: TextAlign.center,
                ),
              ],
              if (actions.isNotEmpty) verticalSpace(16),
              ...actions,
            ],
          ).fadeInScale(),
        ),
      ),
    );
  }
}
