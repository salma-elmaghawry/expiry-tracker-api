import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/models/label_draft.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/widgets/carton_label_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Right side of "Create labels": label number 1, redrawn on every key press.
class LabelPreviewPanel extends StatelessWidget {
  final LabelDraft draft;

  const LabelPreviewPanel({super.key, required this.draft});

  static const _qrFields = [
    'carton_id',
    'barcode',
    'name',
    'category',
    'boxes',
    'per_box',
    'lot',
    'mfg',
    'exp',
    'cost',
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                'factory.preview'.tr(),
                style: AppTextStyles.font18ExtraBold,
              ),
            ),
            Text(
              '100 × 60 mm',
              style: AppTextStyles.font13Bold.secondary(context),
            ),
          ],
        ),
        verticalSpace(14),
        Container(
          padding: EdgeInsets.all(28.r),
          decoration: BoxDecoration(
            color: colorScheme.outlineVariant,
            borderRadius: BorderRadius.circular(16.r),
          ),
          // Shrinks the label on a narrow window instead of overflowing; never grows it.
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: CartonLabelCard(data: draft.previewLabel),
            ),
          ),
        ),
        verticalSpace(14),
        Text(
          'factory.preview_note'.tr(args: ['${draft.count ?? 0}']),
          style: AppTextStyles.font13Medium.secondary(context),
        ),
        verticalSpace(14),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'factory.qr_holds'.tr(),
                style: AppTextStyles.font14ExtraBold,
              ),
              verticalSpace(8),
              Wrap(
                spacing: 6.r,
                runSpacing: 6.r,
                children: [
                  for (final field in _qrFields)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.r,
                        vertical: 3.r,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'factory.qr_fields.$field'.tr(),
                        style: AppTextStyles.font12Bold.secondary(context),
                      ),
                    ),
                ],
              ),
              verticalSpace(8),
              Text(
                'factory.qr_note'.tr(),
                style: AppTextStyles.font12Normal.secondary(context),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
