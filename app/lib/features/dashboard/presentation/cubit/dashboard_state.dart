import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:flutter/foundation.dart';

enum DashboardAction { fetch, loadDemo }

class DashboardState extends BaseState {
  final DashboardSummary? summary;

  /// Open batches that are expired or expire within 3 days, soonest first.
  final List<Batch> needsAction;

  /// False when the store has no batches at all, so we show the empty view.
  final bool hasAnyBatches;

  final DashboardAction? action;
  final Failure? failure;

  const DashboardState({
    super.status = Status.initial,
    super.message,
    this.summary,
    this.needsAction = const [],
    this.hasAnyBatches = false,
    this.action,
    this.failure,
  });

  bool get fetchFailed => isFailure && action == DashboardAction.fetch;

  bool get isLoadingDemo => isLoading && action == DashboardAction.loadDemo;

  DashboardState copyWith({
    Status? status,
    ValueGetter<String?>? message,
    DashboardSummary? summary,
    List<Batch>? needsAction,
    bool? hasAnyBatches,
    DashboardAction? action,
    ValueGetter<Failure?>? failure,
  }) {
    return DashboardState(
      status: status ?? this.status,
      message: message != null ? message() : this.message,
      summary: summary ?? this.summary,
      needsAction: needsAction ?? this.needsAction,
      hasAnyBatches: hasAnyBatches ?? this.hasAnyBatches,
      action: action ?? this.action,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    summary,
    needsAction,
    hasAnyBatches,
    action,
    failure,
  ];
}
