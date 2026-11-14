import 'package:dartz/dartz.dart';
import 'package:expiry_tracker/core/error_handling/error_mapper.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/features/cartons/data/datasources/cartons_remote_datasource.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton_preview.dart';
import 'package:expiry_tracker/features/cartons/domain/repositories/cartons_repository.dart';
import 'package:expiry_tracker/features/cartons/domain/usecases/receive_carton_usecase.dart';

class CartonsRepositoryImpl implements CartonsRepository {
  final CartonsRemoteDataSource _remoteDataSource;

  CartonsRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, CartonPreview>> previewCarton(String qrText) async {
    try {
      final model = await _remoteDataSource.previewCarton(qrText);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
  Future<Either<Failure, Carton>> receiveCarton(
    ReceiveCartonParams params,
  ) async {
    try {
      final model = await _remoteDataSource.receiveCarton(params);
      return Right(model.toEntity());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
