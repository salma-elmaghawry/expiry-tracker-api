import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/domain/expiry.dart';

/// What a carton label means for this store, read BEFORE anything is saved.
class CartonPreview extends Equatable {
  final String cartonCode;
  final String barcode;
  final String productName;
  final Category category;
  final String lotNumber;
  final DateTime productionDate;
  final DateTime expiryDate;
  final int boxesCount;
  final int piecesPerBox;
  final int totalPieces;
  final int costPiasters; // whole carton
  final bool needsSellingPrice; // first carton of this product
  final int? sellingPricePiasters; // saved price, when the product is known
  final DateTime? alreadyReceivedAt;

  const CartonPreview({
    required this.cartonCode,
    required this.barcode,
    required this.productName,
    required this.category,
    required this.lotNumber,
    required this.productionDate,
    required this.expiryDate,
    required this.boxesCount,
    required this.piecesPerBox,
    required this.totalPieces,
    required this.costPiasters,
    required this.needsSellingPrice,
    this.sellingPricePiasters,
    this.alreadyReceivedAt,
  });

  bool get isDuplicate => alreadyReceivedAt != null;

  /// Kept as a double: 40000 / 120 = 333.33 piasters. Round only when showing it.
  double get costPerPiecePiasters => costPiasters / totalPieces;

  int daysLeftFrom(DateTime now) => daysUntil(expiryDate, now);

  ExpiryBucket? urgencyOn(DateTime now) => urgencyFor(daysLeftFrom(now));

  @override
  List<Object?> get props => [
    cartonCode,
    barcode,
    productName,
    category,
    lotNumber,
    productionDate,
    expiryDate,
    boxesCount,
    piecesPerBox,
    totalPieces,
    costPiasters,
    needsSellingPrice,
    sellingPricePiasters,
    alreadyReceivedAt,
  ];
}
