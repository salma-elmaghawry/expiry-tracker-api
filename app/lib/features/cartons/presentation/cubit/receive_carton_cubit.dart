import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/preview_carton_usecase.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/receive_carton_usecase.dart';
import 'package:expiry_tracker/features/cartons/presentation/cubit/receive_carton_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One receiving session: scan, check, save, scan the next one...
class ReceiveCartonCubit extends Cubit<ReceiveCartonState> {
  final PreviewCartonUseCase _previewCarton;
  final ReceiveCartonUseCase _receiveCarton;

  ReceiveCartonCubit(this._previewCarton, this._receiveCarton)
    : super(const ReceiveCartonState());

  /// The camera read [qrText]: ask the API what it is (nothing is saved).
  Future<void> check(String qrText) async {
    emit(
      state.copyWith(
        status: Status.loading,
        action: ReceiveAction.check,
        qrText: () => qrText,
        preview: () => null,
        failure: () => null,
        message: () => null,
      ),
    );

    final result = await _previewCarton(qrText);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: Status.failure,
          action: ReceiveAction.check,
          failure: () => failure,
          message: () => failure.message,
        ),
      ),
      (preview) => emit(
        state.copyWith(
          status: Status.success,
          action: ReceiveAction.check,
          preview: () => preview,
        ),
      ),
    );
  }

  /// "Try again" after a network error: check the same text again.
  Future<void> retryCheck() async {
    final qrText = state.qrText;
    if (qrText != null) await check(qrText);
  }

  Future<void> save({int? sellingPricePiasters, required bool scanNext}) async {
    final qrText = state.qrText;
    final preview = state.preview;
    if (qrText == null || preview == null || state.isSaving) return;

    emit(
      state.copyWith(
        status: Status.loading,
        action: ReceiveAction.save,
        scanNextAfterSave: scanNext,
        failure: () => null,
        message: () => null,
      ),
    );

    final result = await _receiveCarton(
      ReceiveCartonParams(
        qrText: qrText,
        // Only the first carton of a product sends a price.
        sellingPricePiasters: preview.needsSellingPrice
            ? sellingPricePiasters
            : null,
      ),
    );

    await result.fold<Future<void>>(
      (failure) async {
        // 409: someone received it between our check and this save.
        // Check again so the sheet shows "Already received" with the real date.
        if (failure is ConflictFailure) {
          await check(qrText);
          return;
        }
        emit(
          state.copyWith(
            status: Status.failure,
            action: ReceiveAction.save,
            failure: () => failure,
            message: () => failure.message,
          ),
        );
      },
      (carton) async => emit(
        state.copyWith(
          status: Status.success,
          action: ReceiveAction.save,
          lastSaved: () => carton,
          cartonsReceived: state.cartonsReceived + 1,
          piecesReceived: state.piecesReceived + carton.totalPieces,
        ),
      ),
    );
  }

  /// Back to the live camera. The session totals stay.
  void scanNext() {
    emit(
      ReceiveCartonState(
        cartonsReceived: state.cartonsReceived,
        piecesReceived: state.piecesReceived,
        lastSaved: state.lastSaved,
      ),
    );
  }
}
