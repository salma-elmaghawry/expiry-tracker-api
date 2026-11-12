import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/enum_labels.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/helpers/status_tones.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/presentation/models/batch_filters.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/filter_pill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BatchesFilterBar extends StatelessWidget {
  final BatchFilters filters;
  final List<Batch> batches;
  final ValueChanged<BatchStatus?> onStatusSelected;
  final ValueChanged<ExpiryBucket?> onUrgencySelected;

  const BatchesFilterBar({
    super.key,
    required this.filters,
    required this.batches,
    required this.onStatusSelected,
    required this.onUrgencySelected,
  });

  int _countOf(BatchStatus? status) => status == null
      ? batches.length
      : batches.where((batch) => batch.status == status).length;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColors = context.statusColors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Column(
        children: [
          _row([
            for (final status in [null, ...BatchStatus.values])
              FilterPill(
                label: status?.label ?? 'batches.filter_all'.tr(),
                count: '${_countOf(status)}',
                selected: filters.status == status,
                selectedBackground: colorScheme.primaryContainer,
                selectedForeground: colorScheme.onPrimaryContainer,
                selectedBorder: colorScheme.primaryContainer,
                onTap: () => onStatusSelected(status),
              ),
          ]),
          verticalSpace(8),
          _row([
            for (final urgency in ExpiryBucket.values)
              _urgencyPill(urgency, statusColors.forUrgency(urgency)),
          ]),
        ],
      ),
    );
  }

  Widget _urgencyPill(ExpiryBucket urgency, StatusTone tone) {
    final selected = filters.urgency == urgency;
    return FilterPill(
      label: urgency.label,
      icon: urgency.icon,
      iconColor: tone.accent,
      selected: selected,
      selectedBackground: tone.background,
      selectedForeground: tone.foreground,
      selectedBorder: tone.accent,
      onTap: () => onUrgencySelected(selected ? null : urgency),
    );
  }

  Widget _row(List<Widget> pills) {
    return SizedBox(
      height: 40.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsetsDirectional.symmetric(horizontal: 16.w),
        itemCount: pills.length,
        separatorBuilder: (_, _) => horizontalSpace(8),
        itemBuilder: (_, index) => pills[index],
      ),
    );
  }
}
