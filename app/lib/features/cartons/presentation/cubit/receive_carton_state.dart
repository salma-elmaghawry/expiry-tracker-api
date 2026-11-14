import 'package:expiry_tracker/core/bloc/base_bloc.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton_preview.dart';
import 'package:flutter/foundation.dart';

enum ReceiveAction { check, save }

class ReceiveCartonState extends BaseState {
  final ReceiveAction? action;

  /// The QR text being handled. Null means the camera is scanning.
  final String? qrText;
  final CartonPreview? preview;
  final Failure? failure;

  /// Which button started the save: "Save and scan next" or "Save".
  final bool scanNextAfterSave;
  final Carton? lastSaved;

  // Session totals for the panel and the "Done" snackbar.
  final int cartonsReceived;
  final int piecesReceived;

  const ReceiveCartonState({
    super.status = Status.initial,
    super.message,
    this.action,
    this.qrText,
    this.preview,
    this.failure,
    this.scanNextAfterSave = false,
    this.lastSaved,
    this.cartonsReceived = 0,
    this.piecesReceived = 0,
  });

  bool get isScanning => qrText == null;

  bool get isChecking => isLoading && action == ReceiveAction.check;

  bool get checkFailed => isFailure && action == ReceiveAction.check;

  bool get isSaving => isLoading && action == ReceiveAction.save;

  bool get justSaved => isSuccess && action == ReceiveAction.save;

  bool get saveFailed => isFailure && action == ReceiveAction.save;

  ReceiveCartonState copyWith({
    Status? status,
    ValueGetter<String?>? message,
    ReceiveAction? action,
    ValueGetter<String?>? qrText,
    ValueGetter<CartonPreview?>? preview,
    ValueGetter<Failure?>? failure,
    bool? scanNextAfterSave,
    ValueGetter<Carton?>? lastSaved,
    int? cartonsReceived,
    int? piecesReceived,
  }) {
    return ReceiveCartonState(
      status: status ?? this.status,
      message: message != null ? message() : this.message,
      action: action ?? this.action,
      qrText: qrText != null ? qrText() : this.qrText,
      preview: preview != null ? preview() : this.preview,
      failure: failure != null ? failure() : this.failure,
      scanNextAfterSave: scanNextAfterSave ?? this.scanNextAfterSave,
      lastSaved: lastSaved != null ? lastSaved() : this.lastSaved,
      cartonsReceived: cartonsReceived ?? this.cartonsReceived,
      piecesReceived: piecesReceived ?? this.piecesReceived,
    );
  }

  @override
  List<Object?> get props => [
    status,
    message,
    action,
    qrText,
    preview,
    failure,
    scanNextAfterSave,
    lastSaved,
    cartonsReceived,
    piecesReceived,
  ];
}
