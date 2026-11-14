import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/status_tones.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// One colored card: Expired / Within 3 days / 4 to 7 days.
class UrgencyCard extends StatelessWidget {
  final ExpiryBucket bucket;
  final BucketSummary summary;
  final VoidCallback onTap;

  const UrgencyCard({
    super.key,
    required this.bucket,
    required this.summary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tone = context.statusColors.forUrgency(bucket);
    final surface = Theme.of(context).colorScheme.surface;

    return Material(
      color: tone.background,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: 88.h),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            child: Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: surface,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(bucket.icon, size: 24.r, color: tone.accent),
                ),
                horizontalSpace(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bucket.label,
                        style: AppTextStyles.font15ExtraBold.copyWith(
                          color: tone.foreground,
                        ),
                      ),
                      Text(
                        'dashboard.batches_count'.plural(summary.batchCount),
                        style: AppTextStyles.font24ExtraBold.copyWith(
                          color: tone.foreground,
                        ),
                      ),
                      Text(
                        'dashboard.at_cost'.tr(
                          args: [Money.format(summary.valuePiasters)],
                        ),
                        style: AppTextStyles.font13Bold.copyWith(
                          color: tone.foreground,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.r,
                  color: tone.foreground,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
