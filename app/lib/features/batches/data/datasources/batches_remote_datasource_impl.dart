import 'package:dio/dio.dart';
import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/network/api_endpoints.dart';
import 'package:expiry_tracker/features/batches/data/datasources/batches_remote_datasource.dart';
import 'package:expiry_tracker/features/batches/data/models/batch_action_request_model.dart';
import 'package:expiry_tracker/features/batches/data/models/batch_model.dart';
import 'package:expiry_tracker/features/batches/domain/usecases/apply_batch_action_usecase.dart';

class BatchesRemoteDataSourceImpl implements BatchesRemoteDataSource {
  final Dio _dio;

  BatchesRemoteDataSourceImpl(this._dio);

  @override
  Future<List<BatchModel>> getBatches({
    BatchStatus? status,
    ExpiryBucket? bucket,
  }) async {
    final response = await _dio.get<List<dynamic>>(
      ApiEndpoints.batches,
      queryParameters: {
        if (status != null) 'status': status.apiName,
        if (bucket != null) 'bucket': bucket.apiName,
      },
    );

    return [
      for (final item in response.data!)
        BatchModel.fromJson(item as Map<String, dynamic>),
    ];
  }

  @override
  Future<BatchModel> applyAction(ApplyBatchActionParams params) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      ApiEndpoints.batchAction(params.batchId),
      data: BatchActionRequestModel(params).toJson(),
    );

    return BatchModel.fromJson(response.data!);
  }
}
