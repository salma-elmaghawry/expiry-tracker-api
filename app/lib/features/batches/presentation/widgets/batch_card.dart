import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/helpers/date_formatter.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/app_colors.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/category_tile.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/price_view.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/status_chip.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/urgency_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatchCard extends StatelessWidget {
  final Batch batch;
  final VoidCallback? onTap;

  const BatchCard({super.key, required this.batch, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    final radius = BorderRadius.circular(12.r);

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          if (isLight && batch.isOpen)
            BoxShadow(
              color: AppColors.third.withValues(alpha: 0.08),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
        ],
      ),
      child: Material(
        color: colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              children: [
                _topRow(context),
                verticalSpace(10),
                _priceRow(context),
                verticalSpace(10),
                Divider(height: 1, color: colorScheme.outlineVariant),
                verticalSpace(10),
                _bottomRow(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topRow(BuildContext context) {
    final barcode = batch.barcode;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryTile(category: batch.category, muted: !batch.isOpen),
        horizontalSpace(12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                batch.productName,
                style: AppTextStyles.font15ExtraBold,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              verticalSpace(2),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: batch.category.label),
                    if (barcode != null && barcode.isNotEmpty) ...[
                      const TextSpan(text: ' · '),
                      TextSpan(text: '\u2066$barcode\u2069'),
                    ],
                  ],
                ),
                style: AppTextStyles.font12Normal.secondary(context).tabular(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        horizontalSpace(8),
        StatusChip(status: batch.status),
      ],
    );
  }

  Widget _priceRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: '${'batches.qty'.tr()} ',
                style: AppTextStyles.font13Medium.secondary(context),
              ),
              TextSpan(
                text: '${batch.quantity}',
                style: AppTextStyles.font16ExtraBold.tabular(),
              ),
            ],
          ),
        ),
        horizontalSpace(12),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerEnd,
            child: PriceView(batch: batch),
          ),
        ),
      ],
    );
  }

  Widget _bottomRow(BuildContext context) {
    final statusColors = context.statusColors;
    final isWasted = batch.status == BatchStatus.wasted;
    final line = isWasted
        ? 'batches.reason_line'.tr(args: [batch.wasteReason?.label ?? ''])
        : 'batches.expiry_line'.tr(
            args: [AppDateFormatter.short(batch.expiryDate, context.locale)],
          );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            line,
            style: AppTextStyles.font12Normal.secondary(context).tabular(),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        horizontalSpace(8),
        if (batch.isOpen)
          Flexible(child: UrgencyBadge(batch: batch))
        else
          Text(
            isWasted
                ? '−${Money.format(batch.lossPiasters)}'
                : '+${Money.format(batch.saleValuePiasters)}',
            style: AppTextStyles.font13ExtraBold.tabular().copyWith(
              color: isWasted
                  ? statusColors.wasted.foreground
                  : statusColors.sold.foreground,
            ),
          ),
      ],
    );
  }
}
