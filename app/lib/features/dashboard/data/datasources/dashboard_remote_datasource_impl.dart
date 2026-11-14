import 'package:dio/dio.dart';
import 'package:expiry_tracker/core/network/api_endpoints.dart';
import 'package:expiry_tracker/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:expiry_tracker/features/dashboard/data/models/dashboard_summary_model.dart';

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio _dio;

  DashboardRemoteDataSourceImpl(this._dio);

  @override
  Future<DashboardSummaryModel> getSummary() async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.dashboard,
    );
    return DashboardSummaryModel.fromJson(response.data!);
  }

  @override
  Future<void> loadDemoData() async {
    await _dio.post<void>(ApiEndpoints.demoSeed);
  }
}
