import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/status_tones.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/models/batch_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DashboardFilterBanner extends StatelessWidget {
  final BatchFilters filters;
  final List<Batch> batches;
  final VoidCallback onClear;

  const DashboardFilterBanner({
    super.key,
    required this.filters,
    required this.batches,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final urgency = filters.urgency!;
    final tone = context.statusColors.forUrgency(urgency);
    final matching = filters.apply(batches, DateTime.now(), '');
    final atRisk = matching.fold<int>(
      0,
      (sum, batch) => sum + batch.lossPiasters,
    );

    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 4.h),
      padding: EdgeInsetsDirectional.fromSTEB(12.w, 8.h, 4.w, 8.h),
      decoration: BoxDecoration(
        color: tone.background,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(urgency.icon, size: 20.r, color: tone.accent),
          horizontalSpace(10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'batches.banner.title'.tr(args: [urgency.label]),
                  style: AppTextStyles.font13ExtraBold.copyWith(
                    color: tone.foreground,
                  ),
                ),
                Text(
                  'batches.banner.at_risk'.tr(
                    args: ['${matching.length}', Money.format(atRisk)],
                  ),
                  style: AppTextStyles.font12Bold.tabular().copyWith(
                    color: tone.foreground,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: onClear,
            style: TextButton.styleFrom(foregroundColor: tone.foreground),
            child: Text('batches.clear'.tr()),
          ),
        ],
      ),
    ).fadeInSlideUp();
  }
}
