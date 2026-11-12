import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/error_handling/error_mapper.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/batches/data/datasources/batches_remote_datasource.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';
import 'package:expiry_tracker/features/batches/domain/repositories/batches_repository.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';

class BatchesRepositoryImpl implements BatchesRepository {
  final BatchesRemoteDataSource _remoteDataSource;

  BatchesRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<Batch>>> getBatches({
    BatchStatus? status,
    ExpiryBucket? bucket,
  }) async {
    try {
      final models = await _remoteDataSource.getBatches(
        status: status,
        bucket: bucket,
      );
      return Right([for (final model in models) model.toEntity()]);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
  Future<Either<Failure, Batch>> applyAction(
    ApplyBatchActionParams params,
  ) async {
    try {
      final model = await _remoteDataSource.applyAction(params);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
