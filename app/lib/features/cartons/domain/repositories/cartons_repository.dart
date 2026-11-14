import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton_preview.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/receive_carton_usecase.dart';

abstract class CartonsRepository {
  /// Reads the label without saving. [qrText] is exactly what the camera read.
  Future<Either<Failure, CartonPreview>> previewCarton(String qrText);

  /// Saves the carton. Fails with [ConflictFailure] if it was already received.
  Future<Either<Failure, Carton>> receiveCarton(ReceiveCartonParams params);
}
