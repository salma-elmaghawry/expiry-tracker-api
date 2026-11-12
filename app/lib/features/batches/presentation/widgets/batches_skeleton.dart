import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatchesSkeleton extends StatelessWidget {
  const BatchesSkeleton({super.key});

  static const int _placeholderCount = 4;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 24.h),
      itemCount: _placeholderCount,
      separatorBuilder: (_, _) => verticalSpace(10),
      itemBuilder: (_, _) => const _SkeletonCard(),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget bone(double width, double height, {double radius = 6}) =>
        AnimatedSkeleton(
          width: width,
          height: height,
          borderRadius: BorderRadius.circular(radius.r),
          baseColor: colorScheme.outlineVariant,
          highlightColor: colorScheme.surface,
        );

    return Container(
      height: 148.h,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  bone(40.r, 40.r, radius: 12),
                  horizontalSpace(12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      bone(width * 0.55, 14.h),
                      verticalSpace(8),
                      bone(width * 0.35, 10.h),
                    ],
                  ),
                ],
              ),
              verticalSpace(14),
              bone(width, 12.h),
              const Spacer(),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: bone(width * 0.4, 26.h, radius: 8),
              ),
            ],
          );
        },
      ),
    );
  }
}
