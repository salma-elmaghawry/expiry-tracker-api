import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/domain/enums/batch_action_type.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ActionChooserStep extends StatelessWidget {
  final Batch batch;
  final ValueChanged<BatchActionType> onSelected;

  const ActionChooserStep({
    super.key,
    required this.batch,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = context.statusColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'batches.sheet.name_qty'.tr(
            args: [batch.productName, '${batch.quantity}'],
          ),
          style: AppTextStyles.font13ExtraBold.secondary(context),
        ),
        verticalSpace(14),
        _ChooserRow(
          label: 'batches.actions.sell'.tr(),
          icon: Icons.check_rounded,
          rowColor: colorScheme.surfaceContainerHighest,
          labelColor: colorScheme.onSurface,
          iconBackground: colorScheme.primaryContainer,
          iconColor: colorScheme.onPrimaryContainer,
          onTap: () => onSelected(BatchActionType.sell),
        ),
        verticalSpace(10),
        _ChooserRow(
          label: 'batches.actions.discount'.tr(),
          icon: Icons.sell_outlined,
          rowColor: colorScheme.surfaceContainerHighest,
          labelColor: colorScheme.onSurface,
          iconBackground: statusColors.discounted.background,
          iconColor: statusColors.discounted.foreground,
          onTap: () => onSelected(BatchActionType.discount),
        ),
        verticalSpace(10),
        _ChooserRow(
          label: 'batches.actions.waste'.tr(),
          icon: Icons.delete_outline_rounded,
          rowColor: statusColors.wasted.background,
          labelColor: statusColors.wasted.foreground,
          iconBackground: colorScheme.surface,
          iconColor: colorScheme.error,
          onTap: () => onSelected(BatchActionType.waste),
        ),
      ],
    );
  }
}

class _ChooserRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color rowColor;
  final Color labelColor;
  final Color iconBackground;
  final Color iconColor;
  final VoidCallback onTap;

  const _ChooserRow({
    required this.label,
    required this.icon,
    required this.rowColor,
    required this.labelColor,
    required this.iconBackground,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: rowColor,
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: SizedBox(
          height: 56.h,
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Container(
                  width: 36.r,
                  height: 36.r,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20.r, color: iconColor),
                ),
                horizontalSpace(14),
                Text(
                  label,
                  style: AppTextStyles.font16ExtraBold.copyWith(
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
