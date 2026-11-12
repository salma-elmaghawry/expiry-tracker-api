import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/features/batches/data/models/batch_model.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';

abstract class BatchesRemoteDataSource {
  Future<List<BatchModel>> getBatches({
    BatchStatus? status,
    ExpiryBucket? bucket,
  });

  Future<BatchModel> applyAction(ApplyBatchActionParams params);
}
