import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/loading_filled_button.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/sheet_step_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DiscountStep extends StatefulWidget {
  final Batch batch;
  final bool isLoading;
  final bool serverRejectedPrice;
  final ValueChanged<int> onApply;
  final VoidCallback onCancel;

  const DiscountStep({
    super.key,
    required this.batch,
    required this.isLoading,
    required this.serverRejectedPrice,
    required this.onApply,
    required this.onCancel,
  });

  @override
  State<DiscountStep> createState() => _DiscountStepState();
}

class _DiscountStepState extends State<DiscountStep> {
  static const List<int> _quickPercents = [10, 20, 30];

  final _controller = TextEditingController();
  bool _touched = false;

  Batch get _batch => widget.batch;

  int? get _price => Money.tryParsePiasters(_controller.text);

  String? get _error {
    final price = _price;
    if (price == null || price <= 0) {
      return 'batches.sheet.discount_required'.tr();
    }
    if (price >= _batch.unitPricePiasters || widget.serverRejectedPrice) {
      return 'batches.sheet.discount_too_high'.tr(
        args: [Money.format(_batch.unitPricePiasters)],
      );
    }
    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _setPercent(int percent) {
    final price = (_batch.unitPricePiasters * (100 - percent) / 100).round();
    setState(() {
      _controller.text = Money.toInput(price);
      _touched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final discounted = context.statusColors.discounted;
    final error = _error;
    final showError = _touched && error != null;
    final accent = showError ? colorScheme.error : discounted.foreground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SheetStepHeader(
          icon: Icons.sell_outlined,
          iconBackground: discounted.background,
          iconColor: discounted.foreground,
          title: 'batches.sheet.discount_title'.tr(),
          subtitle: 'batches.sheet.name_qty'.tr(
            args: [_batch.productName, '${_batch.quantity}'],
          ),
        ),
        verticalSpace(14),
        Row(
          children: [
            Expanded(
              child: _infoTile(
                context,
                'batches.sheet.selling_price'.tr(),
                _batch.unitPricePiasters,
              ),
            ),
            horizontalSpace(8),
            Expanded(
              child: _infoTile(
                context,
                'batches.sheet.cost_price'.tr(),
                _batch.costPricePiasters,
              ),
            ),
          ],
        ),
        verticalSpace(14),
        Text(
          'batches.sheet.new_price'.tr(),
          style: AppTextStyles.font13ExtraBold.copyWith(color: accent),
        ),
        verticalSpace(6),
        Container(
          height: 56.h,
          padding: EdgeInsetsDirectional.symmetric(horizontal: 14.w),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: accent, width: 2),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  textDirection: TextDirection.ltr,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: AppTextStyles.font22ExtraBold.tabular(),
                  onChanged: (_) => setState(() => _touched = true),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              Text(
                'money.egp'.tr(),
                style: AppTextStyles.font15ExtraBold.secondary(context),
              ),
            ],
          ),
        ),
        if (showError) ...[
          verticalSpace(6),
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 16.r,
                color: colorScheme.error,
              ),
              horizontalSpace(6),
              Expanded(
                child: Text(
                  error,
                  style: AppTextStyles.font13Bold.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
        if (error == null) ..._preview(context, _price!),
        verticalSpace(12),
        Row(
          children: [
            for (final percent in _quickPercents) ...[
              if (percent != _quickPercents.first) horizontalSpace(8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _setPercent(percent),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size.fromHeight(44.h),
                    padding: EdgeInsets.zero,
                    textStyle: AppTextStyles.font14ExtraBold,
                  ),
                  child: Text('−$percent%', textDirection: TextDirection.ltr),
                ),
              ),
            ],
          ],
        ),
        verticalSpace(16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: OutlinedButton(
                onPressed: widget.isLoading ? null : widget.onCancel,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(52.h),
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                ),
                child: Text('common.cancel'.tr(), maxLines: 1),
              ),
            ),
            horizontalSpace(12),
            Expanded(
              flex: 3,
              child: LoadingFilledButton(
                label: 'batches.sheet.discount_confirm'.tr(),
                isLoading: widget.isLoading,
                onPressed: error == null ? () => widget.onApply(_price!) : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _preview(BuildContext context, int price) {
    final discounted = context.statusColors.discounted;
    final warning = context.statusColors.within3Days;
    final percent = Money.percentOff(_batch.unitPricePiasters, price);
    final saving = _batch.unitPricePiasters - price;
    final belowCost = price < _batch.costPricePiasters;

    return [
      verticalSpace(12),
      Row(
        children: [
          Container(
            height: 36.h,
            padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: discounted.background,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              'batches.sheet.percent_off'.tr(args: ['$percent']),
              style: AppTextStyles.font18ExtraBold.copyWith(
                color: discounted.foreground,
              ),
            ),
          ),
          horizontalSpace(12),
          Expanded(
            child: Text(
              'batches.sheet.customers_save'.tr(args: [Money.format(saving)]),
              style: AppTextStyles.font13SemiBold.secondary(context),
            ),
          ),
        ],
      ),
      if (belowCost) ...[
        verticalSpace(10),
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 12.w,
            vertical: 10.h,
          ),
          decoration: BoxDecoration(
            color: warning.background,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 18.r,
                color: warning.accent,
              ),
              horizontalSpace(8),
              Expanded(
                child: Text(
                  'batches.sheet.below_cost'.tr(
                    args: [Money.format(_batch.costPricePiasters - price)],
                  ),
                  style: AppTextStyles.font13Bold.copyWith(
                    color: warning.foreground,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ];
  }

  Widget _infoTile(BuildContext context, String label, int piasters) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 12.w,
        vertical: 10.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.font12ExtraBold.secondary(context)),
          Text(
            Money.format(piasters),
            style: AppTextStyles.font17ExtraBold.tabular(),
          ),
        ],
      ),
    );
  }
}
