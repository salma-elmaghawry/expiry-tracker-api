import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/batch_action_type.dart';
import 'package:expiry_tracker/core/domain/enums/waste_reason.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/domain/repositories/batches_repository.dart';

class ApplyBatchActionParams extends Equatable {
  final int batchId;
  final BatchActionType action;
  final int? discountPricePiasters;
  final WasteReason? wasteReason;

  const ApplyBatchActionParams({
    required this.batchId,
    required this.action,
    this.discountPricePiasters,
    this.wasteReason,
  });

  @override
  List<Object?> get props => [
    batchId,
    action,
    discountPricePiasters,
    wasteReason,
  ];
}

class ApplyBatchActionUseCase
    implements UseCase<Batch, ApplyBatchActionParams> {
  final BatchesRepository _repository;

  ApplyBatchActionUseCase(this._repository);

  @override
  Future<Either<Failure, Batch>> call(ApplyBatchActionParams params) {
    return _repository.applyAction(params);
  }
}
