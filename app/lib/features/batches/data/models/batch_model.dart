import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/enums/waste_reason.dart';
import 'package:expiry_tracker/features/batches/domain/entities/batch.dart';

class BatchModel {
  final int id;
  final String productName;
  final String? barcode;
  final Category category;
  final int quantity;
  final int costPricePiasters;
  final int unitPricePiasters;
  final int? discountPricePiasters;
  final DateTime expiryDate;
  final BatchStatus status;
  final WasteReason? wasteReason;
  final DateTime createdAt;
  final DateTime? actionAt;

  const BatchModel({
    required this.id,
    required this.productName,
    this.barcode,
    required this.category,
    required this.quantity,
    required this.costPricePiasters,
    required this.unitPricePiasters,
    this.discountPricePiasters,
    required this.expiryDate,
    required this.status,
    this.wasteReason,
    required this.createdAt,
    this.actionAt,
  });

  factory BatchModel.fromJson(Map<String, dynamic> json) {
    return BatchModel(
      id: json['id'] as int,
      productName: json['productName'] as String,
      barcode: json['barcode'] as String?,
      category: enumFromApi(Category.values, json['category'] as String),
      quantity: json['quantity'] as int,
      costPricePiasters: json['costPricePiasters'] as int,
      unitPricePiasters: json['unitPricePiasters'] as int,
      discountPricePiasters: json['discountPricePiasters'] as int?,
      expiryDate: _parseCalendarDate(json['expiryDate'] as String),
      status: enumFromApi(BatchStatus.values, json['status'] as String),
      wasteReason: tryEnumFromApi(
        WasteReason.values,
        json['wasteReason'] as String?,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      actionAt: json['actionAt'] == null
          ? null
          : DateTime.parse(json['actionAt'] as String),
    );
  }

  static DateTime _parseCalendarDate(String value) {
    final date = DateTime.parse(value);
    return DateTime.utc(date.year, date.month, date.day);
  }

  Batch toEntity() {
    return Batch(
      id: id,
      productName: productName,
      barcode: barcode,
      category: category,
      quantity: quantity,
      costPricePiasters: costPricePiasters,
      unitPricePiasters: unitPricePiasters,
      discountPricePiasters: discountPricePiasters,
      expiryDate: expiryDate,
      status: status,
      wasteReason: wasteReason,
      createdAt: createdAt,
      actionAt: actionAt,
    );
  }
}
