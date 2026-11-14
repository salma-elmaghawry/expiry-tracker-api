import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/error_mapper.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/factory_labels/data/datasources/labels_remote_datasource.dart';
import 'package:expiry_tracker/features/factory_labels/domain/entities/label_job.dart';
import 'package:expiry_tracker/features/factory_labels/domain/repositories/labels_repository.dart';
import 'package:expiry_tracker/features/factory_labels/domain/usecases/create_label_job_usecase.dart';

class LabelsRepositoryImpl implements LabelsRepository {
  final LabelsRemoteDataSource _remoteDataSource;

  LabelsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, LabelJob>> createJob(
    CreateLabelJobParams params,
  ) async {
    try {
      final model = await _remoteDataSource.createJob(params);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
