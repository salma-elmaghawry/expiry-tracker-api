import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/loading_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionConflictStep extends StatelessWidget {
  final VoidCallback onRefresh;
  final VoidCallback onClose;

  const ActionConflictStep({
    super.key,
    required this.onRefresh,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final tone = context.statusColors.expired;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        verticalSpace(8),
        Center(
          child: Container(
            width: 64.r,
            height: 64.r,
            decoration: BoxDecoration(
              color: tone.background,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.error_outline_rounded,
              size: 30.r,
              color: tone.accent,
            ),
          ),
        ),
        verticalSpace(12),
        Text(
          'batches.sheet.conflict_title'.tr(),
          style: AppTextStyles.font20ExtraBold,
          textAlign: TextAlign.center,
        ),
        verticalSpace(8),
        Text(
          'batches.sheet.conflict_body'.tr(),
          style: AppTextStyles.font16ExtraBold,
          textAlign: TextAlign.center,
        ),
        verticalSpace(8),
        Text(
          'batches.sheet.conflict_hint'.tr(),
          style: AppTextStyles.font14Medium.secondary(context),
          textAlign: TextAlign.center,
        ),
        verticalSpace(20),
        LoadingFilledButton(
          icon: Icons.refresh_rounded,
          label: 'batches.sheet.refresh_list'.tr(),
          onPressed: onRefresh,
        ),
        verticalSpace(4),
        TextButton(
          onPressed: onClose,
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          child: Text('common.close'.tr()),
        ),
      ],
    );
  }
}
