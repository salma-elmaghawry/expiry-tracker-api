import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:expiry_tracker/features/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardUseCase implements UseCase<DashboardSummary, NoParams> {
  final DashboardRepository _repository;

  GetDashboardUseCase(this._repository);

  @override
  Future<Either<Failure, DashboardSummary>> call(NoParams params) {
    return _repository.getSummary();
  }
}
