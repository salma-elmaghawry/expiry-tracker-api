import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:flutter/foundation.dart';

enum BatchesAction { fetch, applyAction }

class BatchesState extends BaseState {
  final List<Batch> batches;
  final bool hasLoaded;
  final BatchesAction? action;
  final Failure? failure;
  final int? actingBatchId;

  const BatchesState({
    super.status = Status.initial,
    super.message,
    this.batches = const [],
    this.hasLoaded = false,
    this.action,
    this.failure,
    this.actingBatchId,
  });

  bool get isFetching => isLoading && action == BatchesAction.fetch;

  bool get fetchFailed => isFailure && action == BatchesAction.fetch;

  bool isActingOn(int batchId) =>
      isLoading &&
      action == BatchesAction.applyAction &&
      actingBatchId == batchId;

  BatchesState copyWith({
    Status? status,
    ValueGetter<String?>? message,
    List<Batch>? batches,
    bool? hasLoaded,
    BatchesAction? action,
    ValueGetter<Failure?>? failure,
    ValueGetter<int?>? actingBatchId,
  }) {
    return BatchesState(
      status: status ?? this.status,
      message: message != null ? message() : this.message,
      batches: batches ?? this.batches,
      hasLoaded: hasLoaded ?? this.hasLoaded,
      action: action ?? this.action,
      failure: failure != null ? failure() : this.failure,
      actingBatchId: actingBatchId != null
          ? actingBatchId()
          : this.actingBatchId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    batches,
    hasLoaded,
    action,
    failure,
    actingBatchId,
  ];
}
