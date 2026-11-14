import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/factory_labels/domain/entities/label_job.dart';
import 'package:flutter/foundation.dart';

class CreateLabelsState extends BaseState {
  final LabelJob? job;
  final Failure? failure;

  const CreateLabelsState({
    super.status,
    super.message,
    this.job,
    this.failure,
  });

  /// Errors the server sent per field ("expiryDate": [...]), shown under each field.
  Map<String, List<String>> get fieldErrors {
    final failure = this.failure;
    return failure is ValidationFailure ? failure.fieldErrors : const {};
  }

  // ValueGetter lets copyWith set a field back to null: copyWith(job: () => null).
  CreateLabelsState copyWith({
    Status? status,
    ValueGetter<String?>? message,
    ValueGetter<LabelJob?>? job,
    ValueGetter<Failure?>? failure,
  }) {
    return CreateLabelsState(
      status: status ?? this.status,
      message: message != null ? message() : this.message,
      job: job != null ? job() : this.job,
      failure: failure != null ? failure() : this.failure,
    );
  }

  @override
  List<Object?> get props => [...super.props, job, failure];
}
