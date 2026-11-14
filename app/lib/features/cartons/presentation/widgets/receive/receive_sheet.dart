import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/helpers/date_formatter.dart';
import 'package:expiry_tracker/core/helpers/enum_icons.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/theme/status_colors.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton_preview.dart';
import 'package:expiry_tracker/features/cartons/presentation/cubit/receive_carton_state.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/receive/carton_details_view.dart';
import 'package:expiry_tracker/features/cartons/presentation/widgets/receive/receive_message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The result sheet over the paused camera: checking, valid carton,
/// already received, not a label, or a network error.
class ReceiveSheet extends StatelessWidget {
  final ReceiveCartonState state;
  final VoidCallback onScanNext;
  final VoidCallback onRetry;
  final void Function(int? sellingPricePiasters, bool scanNext) onSave;

  const ReceiveSheet({
    super.key,
    required this.state,
    required this.onScanNext,
    required this.onRetry,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * 0.86,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 32,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      // Lift the content above the keyboard when the price field is focused.
      padding: EdgeInsets.only(bottom: keyboard),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 16.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 32.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              verticalSpace(14),
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.topCenter,
                child: _content(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _content(BuildContext context) {
    if (state.isChecking) return _checking(context);

    if (state.checkFailed) {
      final failure = state.failure;
      return failure is ValidationFailure
          ? _invalidLabel(context, failure)
          : _networkError(context);
    }

    final preview = state.preview;
    if (preview == null) return const SizedBox.shrink();

    if (preview.isDuplicate) return _duplicate(context, preview);

    return CartonDetailsView(
      // A new carton gets a fresh price field.
      key: ValueKey(preview.cartonCode),
      preview: preview,
      isSaving: state.isSaving,
      savingNext: state.scanNextAfterSave,
      onSave: onSave,
    );
  }

  Widget _checking(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          verticalSpace(14),
          Text(
            'receive.checking'.tr(),
            style: AppTextStyles.font14SemiBold.secondary(context),
          ),
        ],
      ),
    );
  }

  Widget _duplicate(BuildContext context, CartonPreview preview) {
    final colorScheme = Theme.of(context).colorScheme;
    final receivedAt = preview.alreadyReceivedAt!.toLocal();
    final locale = context.locale;
    final date = AppDateFormatter.short(receivedAt, locale);
    final time = DateFormat.Hm(locale.languageCode).format(receivedAt);

    return ReceiveMessageView(
      icon: Icons.library_add_check_outlined,
      tone: context.statusColors.within3Days,
      title: 'receive.dup_title'.tr(),
      body: 'receive.dup_body'.tr(args: [date]),
      hint: 'receive.dup_hint'.tr(),
      card: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                preview.category.icon,
                size: 22.r,
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
                    style: AppTextStyles.font15ExtraBold,
                  ),
                  Text(
                    '${preview.cartonCode} · $time',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.font12Medium
                        .secondary(context)
                        .tabular(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        FilledButton(
          onPressed: onScanNext,
          style: FilledButton.styleFrom(minimumSize: Size.fromHeight(52.h)),
          child: Text('receive.scan_next'.tr()),
        ),
      ],
    );
  }

  Widget _invalidLabel(BuildContext context, ValidationFailure failure) {
    // "qrText" means it is not our label at all. Any other field means our
    // label format, but with wrong values (for example expiry before production).
    final notOurs = failure.fieldErrors.containsKey('qrText');

    return ReceiveMessageView(
      icon: Icons.qr_code_2_rounded,
      tone: context.statusColors.expired,
      title: (notOurs ? 'receive.inv_title' : 'receive.bad_title').tr(),
      body: (notOurs ? 'receive.inv_body' : 'receive.bad_body').tr(),
      hint: (notOurs ? 'receive.inv_hint' : 'receive.bad_hint').tr(),
      actions: [
        FilledButton(
          onPressed: onScanNext,
          style: FilledButton.styleFrom(minimumSize: Size.fromHeight(52.h)),
          child: Text('receive.scan_again'.tr()),
        ),
      ],
    );
  }

  Widget _networkError(BuildContext context) {
    return ReceiveMessageView(
      icon: Icons.wifi_off_rounded,
      tone: context.statusColors.later,
      title: 'batches.error.title'.tr(),
      body: state.message ?? 'errors.network_error'.tr(),
      actions: [
        FilledButton(
          onPressed: onRetry,
          style: FilledButton.styleFrom(minimumSize: Size.fromHeight(52.h)),
          child: Text('receive.try_again'.tr()),
        ),
        OutlinedButton(
          onPressed: onScanNext,
          style: OutlinedButton.styleFrom(minimumSize: Size.fromHeight(48.h)),
          child: Text('receive.scan_again'.tr()),
        ),
      ],
    );
  }
}
