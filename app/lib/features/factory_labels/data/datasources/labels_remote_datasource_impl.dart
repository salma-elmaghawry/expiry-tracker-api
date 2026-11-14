import 'package:dio/dio.dart';
import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/network/api_endpoints.dart';
import 'package:expiry_tracker/features/factory_labels/data/datasources/labels_remote_datasource.dart';
import 'package:expiry_tracker/features/factory_labels/data/models/label_job_model.dart';
import 'package:expiry_tracker/features/factory_labels/domain/usecases/create_label_job_usecase.dart';
import 'package:intl/intl.dart';

class LabelsRemoteDataSourceImpl implements LabelsRemoteDataSource {
  final Dio _dio;

  LabelsRemoteDataSourceImpl(this._dio);

  // The API reads dates as DateOnly: "2026-11-01", no time and no time zone.
  static final DateFormat _apiDate = DateFormat('yyyy-MM-dd');

  // The app never builds or signs the QR: the server does, so only it knows the secret key.
  @override
  Future<LabelJobModel> createJob(CreateLabelJobParams params) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.labelJobs,
      data: {
        'productName': params.productName,
        'barcode': params.barcode,
        'category': params.category.apiName,
        'boxesCount': params.boxesCount,
        'piecesPerBox': params.piecesPerBox,
        'lotNumber': params.lotNumber,
        'productionDate': _apiDate.format(params.productionDate),
        'expiryDate': _apiDate.format(params.expiryDate),
        'costPiasters': params.costPiasters,
        'cartonCount': params.cartonCount,
      },
    );

    return LabelJobModel.fromJson(response.data!);
  }
}
