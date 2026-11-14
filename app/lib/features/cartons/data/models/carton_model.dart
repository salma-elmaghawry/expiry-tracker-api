import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/expiry.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton.dart';

class CartonModel {
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
  final int costPiasters;
  final int? sellingPricePiasters;
  final int? discountPricePiasters;
  final DateTime scannedAt;

  const CartonModel({
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

  factory CartonModel.fromJson(Map<String, dynamic> json) {
    return CartonModel(
      id: json['id'] as int,
      cartonCode: json['cartonCode'] as String,
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      barcode: json['barcode'] as String,
      category: enumFromApi(Category.values, json['category'] as String),
      lotNumber: json['lotNumber'] as String,
      productionDate: parseCalendarDate(json['productionDate'] as String),
      expiryDate: parseCalendarDate(json['expiryDate'] as String),
      boxesCount: json['boxesCount'] as int,
      piecesPerBox: json['piecesPerBox'] as int,
      totalPieces: json['totalPieces'] as int,
      remainingPieces: json['remainingPieces'] as int,
      costPiasters: json['costPiasters'] as int,
      sellingPricePiasters: json['sellingPricePiasters'] as int?,
      discountPricePiasters: json['discountPricePiasters'] as int?,
      scannedAt: DateTime.parse(json['scannedAt'] as String),
    );
  }

  Carton toEntity() {
    return Carton(
      id: id,
      cartonCode: cartonCode,
      productId: productId,
      productName: productName,
      barcode: barcode,
      category: category,
      lotNumber: lotNumber,
      productionDate: productionDate,
      expiryDate: expiryDate,
      boxesCount: boxesCount,
      piecesPerBox: piecesPerBox,
      totalPieces: totalPieces,
      remainingPieces: remainingPieces,
      costPiasters: costPiasters,
      sellingPricePiasters: sellingPricePiasters,
      discountPricePiasters: discountPricePiasters,
      scannedAt: scannedAt,
    );
  }
}
