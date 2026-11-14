import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/error_mapper.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:expiry_tracker/features/dashboard/domain/entities/dashboard_summary.dart';
import 'package:expiry_tracker/features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource _remoteDataSource;

  DashboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DashboardSummary>> getSummary() async {
    try {
      final model = await _remoteDataSource.getSummary();
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
  Future<Either<Failure, Unit>> loadDemoData() async {
    try {
      await _remoteDataSource.loadDemoData();
      return const Right(unit);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
