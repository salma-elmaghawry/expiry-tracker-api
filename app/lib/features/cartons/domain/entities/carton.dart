import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';

/// A carton that the store received. Stock is counted in single pieces.
class Carton extends Equatable {
  final int id;
  final String cartonCode;
  final int productId;
  final String productName;
  final String barcode;
  final Category category;
  final String lotNumber;
  final DateTime productionDate;
  final DateTime expiryDate;
  final int boxesCount;
  final int piecesPerBox;
  final int totalPieces;
  final int remainingPieces;
  final int costPiasters; // whole carton
  final int? sellingPricePiasters; // one piece
  final int? discountPricePiasters; // one piece
  final DateTime scannedAt;

  const Carton({
    required this.id,
    required this.cartonCode,
    required this.productId,
    required this.productName,
    required this.barcode,
    required this.category,
    required this.lotNumber,
    required this.productionDate,
    required this.expiryDate,
    required this.boxesCount,
    required this.piecesPerBox,
    required this.totalPieces,
    required this.remainingPieces,
    required this.costPiasters,
    this.sellingPricePiasters,
    this.discountPricePiasters,
    required this.scannedAt,
  });

  @override
  List<Object?> get props => [
    id,
    cartonCode,
    productId,
    productName,
    barcode,
    category,
    lotNumber,
    productionDate,
    expiryDate,
    boxesCount,
    piecesPerBox,
    totalPieces,
    remainingPieces,
    costPiasters,
    sellingPricePiasters,
    discountPricePiasters,
    scannedAt,
  ];
}
