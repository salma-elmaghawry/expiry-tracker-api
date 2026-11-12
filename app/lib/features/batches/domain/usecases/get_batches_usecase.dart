import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/domain/repositories/batches_repository.dart';

class GetBatchesParams extends Equatable {
  final BatchStatus? status;
  final ExpiryBucket? bucket;

  const GetBatchesParams({this.status, this.bucket});

  @override
  List<Object?> get props => [status, bucket];
}

class GetBatchesUseCase implements UseCase<List<Batch>, GetBatchesParams> {
  final BatchesRepository _repository;

  GetBatchesUseCase(this._repository);

  @override
  Future<Either<Failure, List<Batch>>> call(GetBatchesParams params) {
    return _repository.getBatches(status: params.status, bucket: params.bucket);
  }
}
