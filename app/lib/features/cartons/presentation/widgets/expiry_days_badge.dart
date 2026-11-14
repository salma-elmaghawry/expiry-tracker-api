import 'package:expiry_tracker/core/domain/expiry.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/status_tones.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/urgency_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// "2 days left" chip, coloured by urgency (same colours as the batches list).
class ExpiryDaysBadge extends StatelessWidget {
  final DateTime expiryDate;

  const ExpiryDaysBadge({super.key, required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    final daysLeft = daysUntil(expiryDate, DateTime.now());
    final urgency = urgencyFor(daysLeft);
    final tone = context.statusColors.forUrgency(urgency);

    return Container(
      height: 28.h,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
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
          Text(
            UrgencyBadge.daysText(daysLeft),
            style: AppTextStyles.font13ExtraBold.copyWith(
              color: tone.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
