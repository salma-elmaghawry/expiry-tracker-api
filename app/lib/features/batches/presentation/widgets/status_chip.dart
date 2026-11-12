import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/status_tones.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusChip extends StatelessWidget {
  final BatchStatus status;

  const StatusChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final tone = context.statusColors.forStatus(status);
    return Container(
      height: 26.h,
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w),
      decoration: ShapeDecoration(
        color: tone.background,
        shape: const StadiumBorder(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(status.icon, size: 14.r, color: tone.foreground),
          horizontalSpace(5),
          Text(
            status.label,
            style: AppTextStyles.font12ExtraBold.copyWith(
              color: tone.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
