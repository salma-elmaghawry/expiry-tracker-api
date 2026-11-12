import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/get_batches_usecase.dart';
import 'package:expiry_tracker/features/batches/presentation/cubit/batches_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BatchesCubit extends Cubit<BatchesState> {
  final GetBatchesUseCase _getBatches;
  final ApplyBatchActionUseCase _applyBatchAction;

  BatchesCubit(this._getBatches, this._applyBatchAction)
    : super(const BatchesState());

  Future<void> refresh() async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: BatchesAction.fetch,
        failure: () => null,
        message: () => null,
      ),
    );

    final result = await _getBatches(const GetBatchesParams());

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          action: BatchesAction.fetch,
          failure: () => failure,
          message: () => failure.message,
        ),
      ),
      (batches) => emit(
        state.copyWith(
          status: Status.success,
          action: BatchesAction.fetch,
          batches: batches,
          hasLoaded: true,
        ),
      ),
    );
  }

  Future<void> applyAction(ApplyBatchActionParams params) async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: BatchesAction.applyAction,
        actingBatchId: () => params.batchId,
        failure: () => null,
        message: () => null,
      ),
    );

    final result = await _applyBatchAction(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          action: BatchesAction.applyAction,
          failure: () => failure,
          message: () => failure.message,
        ),
      ),
      (updated) => emit(
        state.copyWith(
          status: Status.success,
          action: BatchesAction.applyAction,
          batches: [
            for (final batch in state.batches)
              batch.id == updated.id ? updated : batch,
          ],
        ),
      ),
    );
  }
}
