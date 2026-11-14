import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/get_batches_usecase.dart';
import 'package:expiry_tracker/features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:expiry_tracker/features/dashboard/domain/usecases/load_demo_data_usecase.dart';
import 'package:expiry_tracker/features/dashboard/presentation/cubit/dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final GetDashboardUseCase _getDashboard;
  final GetBatchesUseCase _getBatches;
  final LoadDemoDataUseCase _loadDemoData;

  DashboardCubit(this._getDashboard, this._getBatches, this._loadDemoData)
    : super(const DashboardState());

  Future<void> load() async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: DashboardAction.fetch,
        failure: () => null,
        message: () => null,
      ),
    );

    // Both requests go out at the same time (like Promise.all in JS).
    final (summaryResult, batchesResult) = await (
      _getDashboard(const NoParams()),
      _getBatches(const GetBatchesParams()),
    ).wait;

    void fail(Failure failure) => emit(
      state.copyWith(
        status: Status.failure,
        action: DashboardAction.fetch,
        failure: () => failure,
        message: () => failure.message,
      ),
    );

    summaryResult.fold(
      fail,
      (summary) => batchesResult.fold(
        fail,
        (batches) => emit(
          state.copyWith(
            status: Status.success,
            action: DashboardAction.fetch,
            summary: summary,
            needsAction: _needsAction(batches),
            hasAnyBatches: batches.isNotEmpty,
          ),
        ),
      ),
    );
  }

  Future<void> loadDemoData() async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: DashboardAction.loadDemo,
        failure: () => null,
        message: () => null,
      ),
    );

    final result = await _loadDemoData(const NoParams());

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          status: Status.failure,
          action: DashboardAction.loadDemo,
          failure: () => failure,
          message: () => failure.message,
        ),
      ),
      (_) => load(),
    );
  }

  static List<Batch> _needsAction(List<Batch> batches) {
    final now = DateTime.now();
    return batches.where((batch) {
      final urgency = batch.urgencyOn(now);
      return urgency == ExpiryBucket.expired ||
          urgency == ExpiryBucket.within3Days;
    }).toList()..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
  }
}
