import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/loading_filled_button.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/sheet_step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SellStep extends StatelessWidget {
  final Batch batch;
  final bool isLoading;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const SellStep({
    super.key,
    required this.batch,
    required this.isLoading,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SheetStepHeader(
          icon: Icons.check_rounded,
          iconBackground: colorScheme.primaryContainer,
          iconColor: colorScheme.onPrimaryContainer,
          title: 'batches.sheet.sell_title'.tr(),
          subtitle: 'batches.sheet.name_qty'.tr(
            args: [batch.productName, '${batch.quantity}'],
          ),
        ),
        verticalSpace(16),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            children: [
              _line(
                context,
                'batches.sheet.quantity'.tr(),
                '${batch.quantity}',
              ),
              verticalSpace(8),
              _line(
                context,
                'batches.sheet.selling_price'.tr(),
                Money.format(batch.currentPricePiasters),
              ),
              verticalSpace(8),
              Divider(height: 1, color: colorScheme.outlineVariant),
              verticalSpace(8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'batches.sheet.total'.tr(),
                    style: AppTextStyles.font15ExtraBold,
                  ),
                  Text(
                    Money.format(batch.saleValuePiasters),
                    style: AppTextStyles.font24ExtraBold.tabular().copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        verticalSpace(16),
        LoadingFilledButton(
          height: 56,
          icon: Icons.check_rounded,
          label: 'batches.sheet.sell_confirm'.tr(),
          isLoading: isLoading,
          onPressed: onConfirm,
        ),
        verticalSpace(4),
        TextButton(
          onPressed: isLoading ? null : onCancel,
          style: TextButton.styleFrom(
            foregroundColor: colorScheme.onSurfaceVariant,
          ),
          child: Text('common.cancel'.tr()),
        ),
      ],
    );
  }

  Widget _line(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.font15Medium.secondary(context)),
        Text(value, style: AppTextStyles.font15ExtraBold.tabular()),
      ],
    );
  }
}
