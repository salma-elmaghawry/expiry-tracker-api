import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton_preview.dart';
import 'package:expiry_tracker/features/cartons/domain/repositories/cartons_repository.dart';

/// Params is the raw QR text.
class PreviewCartonUseCase implements UseCase<CartonPreview, String> {
  final CartonsRepository _repository;

  PreviewCartonUseCase(this._repository);

  @override
  Future<Either<Failure, CartonPreview>> call(String qrText) {
    return _repository.previewCarton(qrText);
  }
}
