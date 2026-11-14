import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/expiry.dart';
import 'package:expiry_tracker/features/cartons/domain/entities/carton_preview.dart';

class CartonPreviewModel {
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
  final int costPiasters;
  final bool needsSellingPrice;
  final int? sellingPricePiasters;
  final DateTime? alreadyReceivedAt;

  const CartonPreviewModel({
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

  factory CartonPreviewModel.fromJson(Map<String, dynamic> json) {
    return CartonPreviewModel(
      cartonCode: json['cartonCode'] as String,
      barcode: json['barcode'] as String,
      productName: json['productName'] as String,
      category: enumFromApi(Category.values, json['category'] as String),
      lotNumber: json['lotNumber'] as String,
      productionDate: parseCalendarDate(json['productionDate'] as String),
      expiryDate: parseCalendarDate(json['expiryDate'] as String),
      boxesCount: json['boxesCount'] as int,
      piecesPerBox: json['piecesPerBox'] as int,
      totalPieces: json['totalPieces'] as int,
      costPiasters: json['costPiasters'] as int,
      needsSellingPrice: json['needsSellingPrice'] as bool,
      sellingPricePiasters: json['sellingPricePiasters'] as int?,
      alreadyReceivedAt: json['alreadyReceivedAt'] == null
          ? null
          : DateTime.parse(json['alreadyReceivedAt'] as String),
    );
  }

  CartonPreview toEntity() {
    return CartonPreview(
      cartonCode: cartonCode,
      barcode: barcode,
      productName: productName,
      category: category,
      lotNumber: lotNumber,
      productionDate: productionDate,
      expiryDate: expiryDate,
      boxesCount: boxesCount,
      piecesPerBox: piecesPerBox,
      totalPieces: totalPieces,
      costPiasters: costPiasters,
      needsSellingPrice: needsSellingPrice,
      sellingPricePiasters: sellingPricePiasters,
      alreadyReceivedAt: alreadyReceivedAt,
    );
  }
}
