import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton.dart';
import 'package:expiry_tracker/features/cartons/domain/repositories/cartons_repository.dart';

class ReceiveCartonParams extends Equatable {
  final String qrText;

  /// Price of ONE piece. Only sent for the first carton of a product.
  final int? sellingPricePiasters;

  const ReceiveCartonParams({required this.qrText, this.sellingPricePiasters});

  @override
  List<Object?> get props => [qrText, sellingPricePiasters];
}

class ReceiveCartonUseCase implements UseCase<Carton, ReceiveCartonParams> {
  final CartonsRepository _repository;

  ReceiveCartonUseCase(this._repository);

  @override
  Future<Either<Failure, Carton>> call(ReceiveCartonParams params) {
    return _repository.receiveCarton(params);
  }
}
