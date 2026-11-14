import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';

/// One printed carton label: the id written under the QR, and the signed text inside the QR.
class CartonLabel extends Equatable {
  final String cartonCode;
  final String qrText;

  const CartonLabel({required this.cartonCode, required this.qrText});

  @override
  List<Object?> get props => [cartonCode, qrText];
}

/// One "Print N labels" click: the form data plus one label per carton.
class LabelJob extends Equatable {
  final int id;
  final String productName;
  final String barcode;
  final Category category;
  final int boxesCount;
  final int piecesPerBox;
  final int piecesPerCarton;
  final String lotNumber;
  final DateTime productionDate;
  final DateTime expiryDate;
  final int costPiasters; // whole carton
  final int cartonCount;
  final List<CartonLabel> labels;

  const LabelJob({
    required this.id,
    required this.productName,
    required this.barcode,
    required this.category,
    required this.boxesCount,
    required this.piecesPerBox,
    required this.piecesPerCarton,
    required this.lotNumber,
    required this.productionDate,
    required this.expiryDate,
    required this.costPiasters,
    required this.cartonCount,
    required this.labels,
  });

  String get firstCartonCode => labels.first.cartonCode;
  String get lastCartonCode => labels.last.cartonCode;

  @override
  List<Object?> get props => [
    id,
    productName,
    barcode,
    category,
    boxesCount,
    piecesPerBox,
    piecesPerCarton,
    lotNumber,
    productionDate,
    expiryDate,
    costPiasters,
    cartonCount,
    labels,
  ];
}
