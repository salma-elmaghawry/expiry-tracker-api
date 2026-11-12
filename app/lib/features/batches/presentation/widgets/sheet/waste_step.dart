import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/domain/enums/waste_reason.dart';
import 'package:expiry_tracker/core/helpers/date_formatter.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/core/widgets/loading_filled_button.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/category_tile.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/sheet_step_header.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/urgency_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WasteStep extends StatefulWidget {
  final Batch batch;
  final bool isLoading;
  final ValueChanged<WasteReason> onConfirm;
  final VoidCallback onCancel;

  const WasteStep({
    super.key,
    required this.batch,
    required this.isLoading,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<WasteStep> createState() => _WasteStepState();
}

class _WasteStepState extends State<WasteStep> {
  WasteReason? _reason;
  bool _showReasonError = false;

  Batch get _batch => widget.batch;

  @override
  void initState() {
    super.initState();
    if (_batch.daysLeftFrom(DateTime.now()) < 0) _reason = WasteReason.expired;
  }

  void _confirm() {
    final reason = _reason;
    if (reason == null) {
      setState(() => _showReasonError = true);
      return;
    }
    widget.onConfirm(reason);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final wasted = context.statusColors.wasted;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SheetStepHeader(
          icon: Icons.delete_outline_rounded,
          iconBackground: wasted.background,
          iconColor: wasted.foreground,
          title: 'batches.sheet.waste_title'.tr(),
          subtitle: 'batches.sheet.waste_subtitle'.tr(),
        ),
        verticalSpace(16),
        _summary(context),
        verticalSpace(16),
        Text('batches.sheet.reason'.tr(), style: AppTextStyles.font14ExtraBold),
        verticalSpace(8),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 3.2,
          children: [
            for (final reason in WasteReason.values)
              _reasonOption(context, reason),
          ],
        ),
        if (_showReasonError) ...[
          verticalSpace(6),
          Text(
            'batches.sheet.reason_required'.tr(),
            style: AppTextStyles.font13Bold.copyWith(color: colorScheme.error),
          ).shake(),
        ],
        verticalSpace(16),
        Container(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          decoration: BoxDecoration(
            color: wasted.background,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'batches.sheet.loss'.tr(),
                      style: AppTextStyles.font13ExtraBold.copyWith(
                        color: wasted.foreground,
                      ),
                    ),
                    Text(
                      '${_batch.quantity} × ${Money.format(_batch.costPricePiasters)}',
                      style: AppTextStyles.font12Bold.tabular().copyWith(
                        color: wasted.foreground,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                Money.format(_batch.lossPiasters),
                style: AppTextStyles.font24ExtraBold.tabular().copyWith(
                  color: wasted.foreground,
                ),
              ),
            ],
          ),
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
                icon: Icons.delete_outline_rounded,
                label: 'batches.sheet.waste_confirm'.tr(),
                isLoading: widget.isLoading,
                backgroundColor: colorScheme.error,
                foregroundColor: colorScheme.onError,
                onPressed: _confirm,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _summary(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          CategoryTile(category: _batch.category),
          horizontalSpace(12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _batch.productName,
                  style: AppTextStyles.font15ExtraBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'batches.sheet.qty_expiry'.tr(
                    args: [
                      '${_batch.quantity}',
                      AppDateFormatter.short(_batch.expiryDate, context.locale),
                    ],
                  ),
                  style: AppTextStyles.font12Normal
                      .secondary(context)
                      .tabular(),
                ),
              ],
            ),
          ),
          horizontalSpace(8),
          Flexible(child: UrgencyBadge(batch: _batch)),
        ],
      ),
    );
  }

  Widget _reasonOption(BuildContext context, WasteReason reason) {
    final colorScheme = Theme.of(context).colorScheme;
    final wasted = context.statusColors.wasted;
    final selected = _reason == reason;
    final color = selected ? wasted.foreground : colorScheme.onSurface;
    final ring = selected ? wasted.foreground : colorScheme.outline;

    return Semantics(
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: selected ? wasted.background : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: ring, width: 1.5),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: () => setState(() {
            _reason = reason;
            _showReasonError = false;
          }),
          child: Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
            child: Row(
              children: [
                Container(
                  width: 18.r,
                  height: 18.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ring, width: 2),
                  ),
                  child: selected
                      ? Container(
                          width: 8.r,
                          height: 8.r,
                          decoration: BoxDecoration(
                            color: wasted.foreground,
                            shape: BoxShape.circle,
                          ),
                        )
                      : null,
                ),
                horizontalSpace(10),
                Expanded(
                  child: Text(
                    reason.label,
                    style: AppTextStyles.font15ExtraBold.copyWith(color: color),
                    overflow: TextOverflow.ellipsis,
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
