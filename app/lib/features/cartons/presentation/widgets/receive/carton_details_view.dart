import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:expiry_tracker/core/helpers/date_formatter.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/loading_filled_button.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton_preview.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/expiry_days_badge.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/receive/selling_price_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A valid carton that was not received yet: its details, the selling price
/// (first carton of a product only), and the two save buttons.
class CartonDetailsView extends StatefulWidget {
  final CartonPreview preview;
  final bool isSaving;
  final bool savingNext;
  final void Function(int? sellingPricePiasters, bool scanNext) onSave;

  const CartonDetailsView({
    super.key,
    required this.preview,
    required this.isSaving,
    required this.savingNext,
    required this.onSave,
  });

  @override
  State<CartonDetailsView> createState() => _CartonDetailsViewState();
}

class _CartonDetailsViewState extends State<CartonDetailsView> {
  final _priceController = TextEditingController();
  int? _pricePiasters;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  bool get _canSave {
    if (widget.isSaving) return false;
    if (!widget.preview.needsSellingPrice) return true;
    return _pricePiasters != null && _pricePiasters! > 0;
  }

  void _save({required bool scanNext}) {
    FocusScope.of(context).unfocus();
    widget.onSave(_pricePiasters, scanNext);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final preview = widget.preview;
    final locale = context.locale;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Icon(
              Icons.check_circle_outline_rounded,
              size: 18.r,
              color: colorScheme.primary,
            ),
            horizontalSpace(8),
            Text(
              'receive.found'.tr(),
              style: AppTextStyles.font13ExtraBold.copyWith(
                color: colorScheme.primary,
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Row(
          children: [
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(
                preview.category.icon,
                size: 26.r,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            horizontalSpace(12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    preview.productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font20ExtraBold,
                  ),
                  Text(
                    preview.category.label,
                    style: AppTextStyles.font13SemiBold.secondary(context),
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpace(12),
        Row(
          children: [
            Expanded(
              child: _InfoTile(
                label: 'receive.lot'.tr(),
                value: preview.lotNumber,
                ltrValue: true,
              ),
            ),
            horizontalSpace(8),
            Expanded(
              child: _InfoTile(
                label: 'receive.mfg'.tr(),
                value: AppDateFormatter.short(preview.productionDate, locale),
              ),
            ),
          ],
        ),
        verticalSpace(8),
        _InfoTile(
          label: 'receive.exp'.tr(),
          value: AppDateFormatter.short(preview.expiryDate, locale),
          trailing: ExpiryDaysBadge(expiryDate: preview.expiryDate),
        ),
        verticalSpace(12),
        _contentsAndCost(context),
        verticalSpace(12),
        if (preview.needsSellingPrice)
          SellingPriceField(
            controller: _priceController,
            pricePiasters: _pricePiasters,
            costPerPiecePiasters: preview.costPerPiecePiasters,
            onChanged: (value) =>
                setState(() => _pricePiasters = Money.tryParsePiasters(value)),
          )
        else if (preview.sellingPricePiasters != null)
          Text(
            'receive.known_price'.tr(
              args: [Money.format(preview.sellingPricePiasters!)],
            ),
            style: AppTextStyles.font13Medium.secondary(context).tabular(),
          ),
        verticalSpace(14),
        LoadingFilledButton(
          label: 'receive.save_next'.tr(),
          icon: Icons.qr_code_scanner_rounded,
          isLoading: widget.isSaving && widget.savingNext,
          onPressed: _canSave ? () => _save(scanNext: true) : null,
        ),
        verticalSpace(8),
        OutlinedButton(
          onPressed: _canSave ? () => _save(scanNext: false) : null,
          style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(48.h)),
          child: widget.isSaving && !widget.savingNext
              ? SizedBox.square(
                  dimension: 20.r,
                  child: const CircularProgressIndicator(strokeWidth: 2.4),
                )
              : Text('receive.save'.tr()),
        ),
      ],
    );
  }

  Widget _contentsAndCost(BuildContext context) {
    final preview = widget.preview;
    final costPerPiece = preview.costPerPiecePiasters.round();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'receive.contents'.tr(),
                  style: AppTextStyles.font12ExtraBold.secondary(context),
                ),
                Text(
                  'receive.pack'.tr(
                    args: [
                      '${preview.boxesCount}',
                      '${preview.piecesPerBox}',
                      '${preview.totalPieces}',
                    ],
                  ),
                  style: AppTextStyles.font17ExtraBold.tabular(),
                ),
              ],
            ),
          ),
          horizontalSpace(12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'receive.cost'.tr(),
                style: AppTextStyles.font12ExtraBold.secondary(context),
              ),
              Text(
                Money.format(preview.costPiasters),
                style: AppTextStyles.font17ExtraBold.tabular(),
              ),
              Text(
                'receive.per_piece'.tr(args: [Money.format(costPerPiece)]),
                style: AppTextStyles.font12Medium.secondary(context).tabular(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String label;
  final String value;
  final bool ltrValue;
  final Widget? trailing;

  const _InfoTile({
    required this.label,
    required this.value,
    this.ltrValue = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.font12ExtraBold.secondary(context),
                ),
                Text(
                  value,
                  // Lot numbers like "L-2611-A" read left to right in Arabic too.
                  textDirection: ltrValue ? TextDirection.ltr : null,
                  style: AppTextStyles.font15ExtraBold.tabular(),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[horizontalSpace(8), trailing!],
        ],
      ),
    );
  }
}
