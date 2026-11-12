import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/animations/animations.dart';
import 'package:expiry_tracker/core/domain/enums/batch_action_type.dart';
import 'package:expiry_tracker/core/domain/enums/waste_reason.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/helpers/ui_helpers.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_cubit.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_state.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/action_chooser_step.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/action_conflict_step.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/discount_step.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/sell_step.dart';
import 'package:expiry_tracker/features/batches/presentation/widgets/sheet/waste_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _SheetStep { chooser, sell, discount, waste, conflict }

class BatchActionsSheet extends StatefulWidget {
  final Batch batch;

  const BatchActionsSheet({super.key, required this.batch});

  static const double _fabClearance = 64;

  static Future<void> show(BuildContext context, Batch batch) {
    final cubit = context.read<BatchesCubit>();
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => BlocProvider.value(
        value: cubit,
        child: BatchActionsSheet(batch: batch),
      ),
    );
  }

  @override
  State<BatchActionsSheet> createState() => _BatchActionsSheetState();
}

class _BatchActionsSheetState extends State<BatchActionsSheet> {
  static const String _discountField = 'discountPricePiasters';

  _SheetStep _step = _SheetStep.chooser;
  BatchActionType? _pendingAction;
  bool _serverRejectedPrice = false;

  Batch get _batch => widget.batch;

  void _submit(BatchActionType action, {int? discount, WasteReason? reason}) {
    _pendingAction = action;
    _serverRejectedPrice = false;
    context.read<BatchesCubit>().applyAction(
      ApplyBatchActionParams(
        batchId: _batch.id,
        action: action,
        discountPricePiasters: discount,
        wasteReason: reason,
      ),
    );
  }

  void _onStateChanged(BuildContext context, BatchesState state) {
    if (state.isSuccess) {
      showAppSnackBar(
        context,
        'batches.done.${_pendingAction!.name}'.tr(args: [_batch.productName]),
        bottomOffset: BatchActionsSheet._fabClearance,
      );
      Navigator.of(context).pop();
      return;
    }

    final failure = state.failure;
    if (failure is ConflictFailure || failure is NotFoundFailure) {
      setState(() => _step = _SheetStep.conflict);
    } else if (failure is ValidationFailure &&
        failure.fieldErrors.containsKey(_discountField)) {
      setState(() => _serverRejectedPrice = true);
    } else {
      showAppSnackBar(
        context,
        state.message ?? '',
        isError: true,
        bottomOffset: BatchActionsSheet._fabClearance,
      );
    }
  }

  void _close() => Navigator.of(context).pop();

  void _refreshAndClose() {
    context.read<BatchesCubit>().refresh();
    _close();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BatchesCubit, BatchesState>(
      listenWhen: (previous, current) =>
          current.action == BatchesAction.applyAction &&
          current.actingBatchId == _batch.id &&
          (current.isSuccess || current.isFailure) &&
          previous.status != current.status,
      listener: _onStateChanged,
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(
          16.w,
          0,
          16.w,
          MediaQuery.viewInsetsOf(context).bottom + 20.h,
        ),
        child: SingleChildScrollView(
          child: AnimatedSize(
            duration: AppAnimations.normal,
            curve: AppAnimations.defaultCurve,
            alignment: Alignment.topCenter,
            child: AnimatedSwitcher(
              duration: AppAnimations.fast,
              child: KeyedSubtree(
                key: ValueKey(_step),
                child: BlocBuilder<BatchesCubit, BatchesState>(
                  builder: (context, state) =>
                      _stepView(state.isActingOn(_batch.id)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _stepView(bool isLoading) {
    switch (_step) {
      case _SheetStep.chooser:
        return ActionChooserStep(
          batch: _batch,
          onSelected: (action) => setState(
            () => _step = switch (action) {
              BatchActionType.sell => _SheetStep.sell,
              BatchActionType.discount => _SheetStep.discount,
              BatchActionType.waste => _SheetStep.waste,
            },
          ),
        );
      case _SheetStep.sell:
        return SellStep(
          batch: _batch,
          isLoading: isLoading,
          onConfirm: () => _submit(BatchActionType.sell),
          onCancel: _close,
        );
      case _SheetStep.discount:
        return DiscountStep(
          batch: _batch,
          isLoading: isLoading,
          serverRejectedPrice: _serverRejectedPrice,
          onApply: (price) =>
              _submit(BatchActionType.discount, discount: price),
          onCancel: _close,
        );
      case _SheetStep.waste:
        return WasteStep(
          batch: _batch,
          isLoading: isLoading,
          onConfirm: (reason) => _submit(BatchActionType.waste, reason: reason),
          onCancel: _close,
        );
      case _SheetStep.conflict:
        return ActionConflictStep(onRefresh: _refreshAndClose, onClose: _close);
    }
  }
}
