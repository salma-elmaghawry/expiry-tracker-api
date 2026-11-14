import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/factory_labels/domain/entities/label_job.dart';
import 'package:expiry_tracker/features/factory_labels/domain/usecases/create_label_job_usecase.dart';

abstract class LabelsRepository {
  /// Creates unique carton ids and signed QRs. Fails with [ValidationFailure] on bad form data.
  Future<Either<Failure, LabelJob>> createJob(CreateLabelJobParams params);
}
