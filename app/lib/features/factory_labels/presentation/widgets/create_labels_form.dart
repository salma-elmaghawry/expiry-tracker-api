import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/loading_filled_button.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/models/label_draft.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/widgets/label_form_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The "Create carton labels" card. Stateless: the screen owns the controllers
/// and rebuilds this with a fresh [LabelDraft] on every change.
class CreateLabelsForm extends StatelessWidget {
  final LabelFormControllers controllers;
  final LabelDraft draft;
  final Map<String, List<String>> serverErrors; // keys are the API field names
  final bool isSubmitting;
  final ValueChanged<Category> onCategoryChanged;
  final VoidCallback onPickProductionDate;
  final VoidCallback onPickExpiryDate;
  final VoidCallback onSubmit;

  const CreateLabelsForm({
    super.key,
    required this.controllers,
    required this.draft,
    required this.serverErrors,
    required this.isSubmitting,
    required this.onCategoryChanged,
    required this.onPickProductionDate,
    required this.onPickExpiryDate,
    required this.onSubmit,
  });

  // Our own check first; if it passes, show what the server said (if anything).
  String? _error(String? local, String apiField) =>
      local ?? serverErrors[apiField]?.first;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final pieces = draft.piecesPerCarton;
    final cost = draft.costPiasters;
    final count = draft.count ?? 0;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Field(
            label: 'factory.fields.name'.tr(),
            child: TextField(
              controller: controllers.name,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'factory.hints.name'.tr(),
                errorText: _error(null, 'productName'),
              ),
            ),
          ),
          _Pair(
            left: _Field(
              label: 'factory.fields.barcode'.tr(),
              child: TextField(
                controller: controllers.barcode,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                textInputAction: TextInputAction.next,
                style: AppTextStyles.font16Medium.tabular(),
                decoration: InputDecoration(
                  hintText: '6223001360210',
                  errorText: _error(draft.barcodeError, 'barcode'),
                ),
              ),
            ),
            right: _Field(
              label: 'factory.fields.category'.tr(),
              child: DropdownButtonFormField<Category>(
                initialValue: draft.category,
                items: [
                  for (final category in Category.values)
                    DropdownMenuItem(
                      value: category,
                      child: Text(category.label),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) onCategoryChanged(value);
                },
              ),
            ),
          ),
          _Pair(
            left: _Field(
              label: 'factory.fields.boxes'.tr(),
              child: _NumberField(
                controller: controllers.boxes,
                hint: '12',
                errorText: _error(draft.boxesError, 'boxesCount'),
              ),
            ),
            right: _Field(
              label: 'factory.fields.per_box'.tr(),
              child: _NumberField(
                controller: controllers.perBox,
                hint: '10',
                errorText: _error(draft.perBoxError, 'piecesPerBox'),
              ),
            ),
          ),
          if (pieces > 0)
            Padding(
              padding: EdgeInsets.only(bottom: 14.r),
              child: Text(
                'factory.pieces_per_carton'.tr(args: ['$pieces']),
                style: AppTextStyles.font13Bold.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          _Field(
            label: 'factory.fields.lot'.tr(),
            child: TextField(
              controller: controllers.lot,
              textDirection: TextDirection.ltr,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: 'ED-2611-07',
                errorText: _error(null, 'lotNumber'),
              ),
            ),
          ),
          _Pair(
            left: _Field(
              label: 'factory.fields.mfg'.tr(),
              child: _DateField(
                date: draft.productionDate,
                onTap: onPickProductionDate,
              ),
            ),
            right: _Field(
              label: 'factory.fields.exp'.tr(),
              child: _DateField(
                date: draft.expiryDate,
                onTap: onPickExpiryDate,
                errorText: _error(draft.expiryError, 'expiryDate'),
              ),
            ),
          ),
          _Pair(
            left: _Field(
              label: 'factory.fields.cost'.tr(),
              helper: pieces > 0 && cost != null && cost > 0
                  ? 'factory.per_piece'.tr(
                      args: [Money.format((cost / pieces).round())],
                    )
                  : null,
              child: TextField(
                controller: controllers.cost,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textDirection: TextDirection.ltr,
                textInputAction: TextInputAction.next,
                style: AppTextStyles.font16Medium.tabular(),
                decoration: InputDecoration(
                  hintText: '840.00',
                  suffixText: 'money.egp'.tr(),
                  errorText: _error(draft.costError, 'costPiasters'),
                ),
              ),
            ),
            right: _Field(
              label: 'factory.fields.count'.tr(),
              child: _NumberField(
                controller: controllers.count,
                hint: '50',
                errorText: _error(draft.countError, 'cartonCount'),
                onSubmitted: draft.isComplete ? onSubmit : null,
              ),
            ),
          ),
          Divider(height: 1, color: colorScheme.outlineVariant),
          verticalSpace(16),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: SizedBox(
              width: 260.r,
              child: LoadingFilledButton(
                label: 'factory.print_n'.tr(args: ['$count']),
                icon: Icons.print_outlined,
                isLoading: isSubmitting,
                height: 48,
                // Disabled until every field passes, as in the design.
                onPressed: draft.isComplete ? onSubmit : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Bold label above an input, like the design (not Material's floating label).
class _Field extends StatelessWidget {
  final String label;
  final String? helper;
  final Widget child;

  const _Field({required this.label, required this.child, this.helper});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 14.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.font13ExtraBold),
          verticalSpace(6),
          child,
          if (helper != null) ...[
            verticalSpace(6),
            Text(helper!, style: AppTextStyles.font12Normal.secondary(context)),
          ],
        ],
      ),
    );
  }
}

/// Two fields side by side; stacked when the card is narrow (phone browser).
class _Pair extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _Pair({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 420) {
          return Column(children: [left, right]);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: left),
            horizontalSpace(16),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String? errorText;
  final VoidCallback? onSubmitted;

  const _NumberField({
    required this.controller,
    required this.hint,
    this.errorText,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textDirection: TextDirection.ltr,
      textInputAction: onSubmitted == null
          ? TextInputAction.next
          : TextInputAction.done,
      onSubmitted: onSubmitted == null ? null : (_) => onSubmitted!(),
      style: AppTextStyles.font16Medium.tabular(),
      decoration: InputDecoration(hintText: hint, errorText: errorText),
    );
  }
}

/// Looks like a text field, opens the date picker when tapped.
class _DateField extends StatelessWidget {
  final DateTime? date;
  final VoidCallback onTap;
  final String? errorText;

  const _DateField({required this.date, required this.onTap, this.errorText});

  @override
  Widget build(BuildContext context) {
    final text = date == null ? null : DateFormat('dd/MM/yyyy').format(date!);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: InputDecorator(
        isEmpty: text == null,
        decoration: InputDecoration(
          hintText: 'dd/mm/yyyy',
          errorText: errorText,
          suffixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: text == null
            ? null
            : Text(
                text,
                textDirection: TextDirection.ltr,
                style: AppTextStyles.font16Medium.tabular(),
              ),
      ),
    );
  }
}
