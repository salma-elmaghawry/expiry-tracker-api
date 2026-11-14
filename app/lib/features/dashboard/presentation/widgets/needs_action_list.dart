import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/routes/routes.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/category_tile.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/urgency_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

/// "Needs action today": expired or within 3 days, soonest first.
class NeedsActionList extends StatelessWidget {
  static const int _maxRows = 5;

  final List<Batch> batches;

  const NeedsActionList({super.key, required this.batches});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rows = batches.take(_maxRows).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'dashboard.needs_action'.tr(),
                style: AppTextStyles.font16ExtraBold,
              ),
            ),
            TextButton(
              onPressed: () => context.go(Routes.batches),
              child: Text('dashboard.see_all'.tr()),
            ),
          ],
        ),
        verticalSpace(4),
        Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: colorScheme.outlineVariant),
          ),
          child: rows.isEmpty
              ? Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Text(
                    'dashboard.all_clear'.tr(),
                    style: AppTextStyles.font14Medium.secondary(context),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < rows.length; i++) ...[
                      if (i > 0)
                        Divider(height: 1, color: colorScheme.outlineVariant),
                      _NeedsActionRow(batch: rows[i]),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _NeedsActionRow extends StatelessWidget {
  final Batch batch;

  const _NeedsActionRow({required this.batch});

  @override
  Widget build(BuildContext context) {
    final urgency = batch.urgencyOn(DateTime.now());

    return InkWell(
      // Opens Batches filtered to the same urgency, where the actions live.
      onTap: () => context.go(
        Routes.batchesWith(urgency: urgency, fromDashboardCard: true),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 60.h),
        child: Padding(
          padding: EdgeInsetsDirectional.symmetric(
            horizontal: 12.w,
            vertical: 8.h,
          ),
          child: Row(
            children: [
              CategoryTile(category: batch.category),
              horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      batch.productName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.font15ExtraBold,
                    ),
                    Text(
                      'dashboard.row_meta'.tr(
                        args: [
                          '${batch.quantity}',
                          Money.format(batch.lossPiasters),
                        ],
                      ),
                      style: AppTextStyles.font12Medium.secondary(context),
                    ),
                  ],
                ),
              ),
              horizontalSpace(8),
              UrgencyBadge(batch: batch),
            ],
          ),
        ),
      ),
    );
  }
}
