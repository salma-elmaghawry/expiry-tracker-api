import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/status_tones.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UrgencyBadge extends StatelessWidget {
  final Batch batch;

  const UrgencyBadge({super.key, required this.batch});

  static String daysText(int daysLeft) {
    if (daysLeft < 0) return 'batches.days.expired_ago'.plural(-daysLeft);
    if (daysLeft == 0) return 'batches.days.today'.tr();
    return 'batches.days.left'.plural(daysLeft);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final urgency = batch.urgencyOn(now);
    final tone = context.statusColors.forUrgency(urgency);

    return Container(
      height: 26.h,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            urgency?.icon ?? laterUrgencyIcon,
            size: 14.r,
            color: tone.accent,
          ),
          horizontalSpace(5),
          Flexible(
            child: Text(
              daysText(batch.daysLeftFrom(now)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.font12ExtraBold.copyWith(
                color: tone.foreground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
