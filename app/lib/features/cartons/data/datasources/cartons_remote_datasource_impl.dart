import 'package:dio/dio.dart';
import 'package:expiry_tracker/core/network/api_endpoints.dart';
import 'package:expiry_tracker/features/cartons/data/datasources/cartons_remote_datasource.dart';
import 'package:expiry_tracker/features/cartons/data/models/carton_model.dart';
import 'package:expiry_tracker/features/cartons/data/models/carton_preview_model.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/receive_carton_usecase.dart';

class CartonsRemoteDataSourceImpl implements CartonsRemoteDataSource {
  final Dio _dio;

  CartonsRemoteDataSourceImpl(this._dio);

  // The app never parses the QR itself: it sends the text as it was read,
  // and the API (the only place that knows the label format) reads it.
  @override
  Future<CartonPreviewModel> previewCarton(String qrText) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.cartonScanPreview,
      data: {'qrText': qrText},
    );

    return CartonPreviewModel.fromJson(response.data!);
  }

  @override
  Future<CartonModel> receiveCarton(ReceiveCartonParams params) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.cartonScan,
      data: {
        'qrText': params.qrText,
        if (params.sellingPricePiasters != null)
          'sellingPricePiasters': params.sellingPricePiasters,
      },
    );

    return CartonModel.fromJson(response.data!);
  }
}
