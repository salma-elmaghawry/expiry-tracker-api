import 'package:expiry_tracker/features/factory_labels/data/models/label_job_model.dart';
import 'package:expiry_tracker/features/factory_labels/domain/usecases/create_label_job_usecase.dart';

abstract class LabelsRemoteDataSource {
  Future<LabelJobModel> createJob(CreateLabelJobParams params);
}
