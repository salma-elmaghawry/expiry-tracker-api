import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/dashboard/domain/entities/dashboard_summary.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardSummary>> getSummary();

  /// Wipes all batches on the server and adds the demo set.
  Future<Either<Failure, Unit>> loadDemoData();
}
