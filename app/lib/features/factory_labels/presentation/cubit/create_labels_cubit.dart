import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/features/factory_labels/domain/usecases/create_label_job_usecase.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/cubit/create_labels_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Sends the label form to the API. The form itself (text fields, live preview)
/// lives in the widget, because it changes on every key press.
class CreateLabelsCubit extends Cubit<CreateLabelsState> {
  final CreateLabelJobUseCase _createLabelJob;

  CreateLabelsCubit(this._createLabelJob) : super(const CreateLabelsState());

  Future<void> create(CreateLabelJobParams params) async {
    if (state.isLoading) return;

    emit(
      state.copyWith(
        status: Status.loading,
        job: () => null,
        failure: () => null,
        message: () => null,
      ),
    );

    final result = await _createLabelJob(params);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          failure: () => failure,
          message: () => failure.message,
        ),
      ),
      (job) => emit(state.copyWith(status: Status.success, job: () => job)),
    );
  }

  /// The user edited the form after a server error: hide the old field errors.
  void clearErrors() {
    if (state.failure == null) return;
    emit(
      state.copyWith(
        status: Status.initial,
        failure: () => null,
        message: () => null,
      ),
    );
  }
}
