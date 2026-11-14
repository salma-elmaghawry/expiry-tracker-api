import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Selling price of ONE piece, asked only for the first carton of a product.
/// The hint under it shows the margin against the cost per piece as you type.
class SellingPriceField extends StatelessWidget {
  final TextEditingController controller;
  final int? pricePiasters;
  final double costPerPiecePiasters;
  final ValueChanged<String> onChanged;

  const SellingPriceField({
    super.key,
    required this.controller,
    required this.pricePiasters,
    required this.costPerPiecePiasters,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final (hint, color) = _hint(context);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12.r),
      borderSide: BorderSide(color: color, width: 2),
    );

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text.rich(
                  TextSpan(
                    text: '${'receive.price_label'.tr()} ',
                    children: [
                      TextSpan(
                        text: '*',
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ],
                  ),
                  style: AppTextStyles.font13ExtraBold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'receive.once'.tr(),
                  style: AppTextStyles.font10Bold.copyWith(
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
          verticalSpace(6),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textDirection: TextDirection.ltr,
            style: AppTextStyles.font20ExtraBold.tabular(),
            decoration: InputDecoration(
              hintText: '0.00',
              suffixText: 'money.egp'.tr(),
              filled: true,
              fillColor: colorScheme.surface,
              enabledBorder: border,
              focusedBorder: border,
            ),
          ),
          verticalSpace(6),
          Text(
            hint,
            style: AppTextStyles.font13Bold.copyWith(color: color).tabular(),
          ),
        ],
      ),
    );
  }

  /// Empty: required. At or below cost: allowed, but amber. Above cost: margin.
  (String, Color) _hint(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final price = pricePiasters;

    if (price == null || price <= 0) {
      return ('receive.price_required'.tr(), colorScheme.error);
    }

    if (price <= costPerPiecePiasters) {
      return (
        'receive.price_below_cost'.tr(
          args: [Money.format(costPerPiecePiasters.round())],
        ),
        context.statusColors.within3Days.foreground,
      );
    }

    final margin = price - costPerPiecePiasters;
    final percent = (margin / price * 100).round();
    return (
      'receive.margin'.tr(args: [Money.format(margin.round()), '$percent']),
      colorScheme.primary,
    );
  }
}
