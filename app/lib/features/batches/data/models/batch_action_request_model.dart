import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';

class BatchActionRequestModel {
  final ApplyBatchActionParams params;

  const BatchActionRequestModel(this.params);

  Map<String, dynamic> toJson() {
    return {
      'action': params.action.apiName,
      if (params.discountPricePiasters != null)
        'discountPricePiasters': params.discountPricePiasters,
      if (params.wasteReason != null)
        'wasteReason': params.wasteReason!.apiName,
    };
  }
}
