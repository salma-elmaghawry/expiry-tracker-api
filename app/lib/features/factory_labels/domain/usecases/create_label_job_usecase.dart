import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/error_handling/failures.dart';
import 'package:expiry_tracker/core/usecase/usecase.dart';
import 'package:expiry_tracker/features/factory_labels/domain/entities/label_job.dart';
import 'package:expiry_tracker/features/factory_labels/domain/repositories/labels_repository.dart';

class CreateLabelJobParams extends Equatable {
  final String productName;
  final String barcode;
  final Category category;
  final int boxesCount;
  final int piecesPerBox;
  final String lotNumber;
  final DateTime productionDate;
  final DateTime expiryDate;
  final int costPiasters; // whole carton
  final int cartonCount;

  const CreateLabelJobParams({
    required this.productName,
    required this.barcode,
    required this.category,
    required this.boxesCount,
    required this.piecesPerBox,
    required this.lotNumber,
    required this.productionDate,
    required this.expiryDate,
    required this.costPiasters,
    required this.cartonCount,
  });

  @override
  List<Object?> get props => [
    productName,
    barcode,
    category,
    boxesCount,
    piecesPerBox,
    lotNumber,
    productionDate,
    expiryDate,
    costPiasters,
    cartonCount,
  ];
}

class CreateLabelJobUseCase implements UseCase<LabelJob, CreateLabelJobParams> {
  final LabelsRepository _repository;

  CreateLabelJobUseCase(this._repository);

  @override
  Future<Either<Failure, LabelJob>> call(CreateLabelJobParams params) {
    return _repository.createJob(params);
  }
}
