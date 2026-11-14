import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Grey placeholders shaped like the three urgency cards and the list.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget bone(double height, {double radius = 16}) => AnimatedSkeleton(
      width: double.infinity,
      height: height,
      borderRadius: BorderRadius.circular(radius.r),
      baseColor: colorScheme.outlineVariant,
      highlightColor: colorScheme.surface,
    );

    return ListView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 8.h, 16.w, 24.h),
      children: [
        for (var i = 0; i < 3; i++) ...[bone(88.h), verticalSpace(12)],
        verticalSpace(12),
        bone(200.h, radius: 12),
      ],
    );
  }
}
