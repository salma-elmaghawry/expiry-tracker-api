import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PriceView extends StatelessWidget {
  final Batch batch;

  const PriceView({super.key, required this.batch});

  @override
  Widget build(BuildContext context) {
    final discount = batch.discountPricePiasters;
    if (discount == null) {
      return Text(
        Money.format(batch.unitPricePiasters),
        style: AppTextStyles.font16ExtraBold.tabular(),
      );
    }

    final tone = context.statusColors.discounted;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Money.formatNumber(batch.unitPricePiasters),
          style: AppTextStyles.font13Medium
              .secondary(context)
              .tabular()
              .copyWith(decoration: TextDecoration.lineThrough),
        ),
        horizontalSpace(8),
        Text(
          Money.format(discount),
          style: AppTextStyles.font16ExtraBold.tabular().copyWith(
            color: tone.foreground,
          ),
        ),
        horizontalSpace(8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: tone.background,
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Text(
            '−${Money.percentOff(batch.unitPricePiasters, discount)}%',
            textDirection: TextDirection.ltr,
            style: AppTextStyles.font12ExtraBold.copyWith(
              color: tone.foreground,
            ),
          ),
        ),
      ],
    );
  }
}
