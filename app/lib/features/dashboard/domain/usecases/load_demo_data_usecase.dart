import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/dashboard/domain/repositories/dashboard_repository.dart';

class LoadDemoDataUseCase implements UseCase<Unit, NoParams> {
  final DashboardRepository _repository;

  LoadDemoDataUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(NoParams params) {
    return _repository.loadDemoData();
  }
}
