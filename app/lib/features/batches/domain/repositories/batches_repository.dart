import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';

abstract class BatchesRepository {
  Future<Either<Failure, List<Batch>>> getBatches({
    BatchStatus? status,
    ExpiryBucket? bucket,
  });

  Future<Either<Failure, Batch>> applyAction(ApplyBatchActionParams params);
}
