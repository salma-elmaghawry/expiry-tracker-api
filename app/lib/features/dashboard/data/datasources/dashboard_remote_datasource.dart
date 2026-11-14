import 'package:expiry_tracker/features/dashboard/data/models/dashboard_summary_model.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardSummaryModel> getSummary();

  Future<void> loadDemoData();
}
