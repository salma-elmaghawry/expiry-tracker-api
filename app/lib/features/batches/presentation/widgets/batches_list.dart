import 'dart:math';

import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/batch_card.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/batch_actions_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatchesList extends StatelessWidget {
  final List<Batch> batches;
  final Future<void> Function() onRefresh;

  const BatchesList({
    super.key,
    required this.batches,
    required this.onRefresh,
  });

  static const int _maxStaggeredItems = 8;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsetsDirectional.fromSTEB(16.w, 4.h, 16.w, 96.h),
        itemCount: batches.length,
        separatorBuilder: (_, _) => verticalSpace(10),
        itemBuilder: (context, index) {
          final batch = batches[index];
          return BatchCard(
            key: ValueKey(batch.id),
            batch: batch,
            onTap: batch.isOpen
                ? () => BatchActionsSheet.show(context, batch)
                : null,
          ).fadeInSlideUp(
            delay: AppAnimations.staggerDelay * min(index, _maxStaggeredItems),
          );
        },
      ),
    );
  }
}
