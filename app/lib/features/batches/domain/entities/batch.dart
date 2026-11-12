import 'package:equatable/equatable.dart';
import 'package:expiry_tracker/core/domain/enums/batch_status.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/enums/expiry_bucket.dart';
import 'package:expiry_tracker/core/domain/enums/waste_reason.dart';

class Batch extends Equatable {
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

  const Batch({
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

  bool get isOpen =>
      status == BatchStatus.active || status == BatchStatus.discounted;

  int get currentPricePiasters => discountPricePiasters ?? unitPricePiasters;

  int daysLeftFrom(DateTime now) {
    final today = DateTime.utc(now.year, now.month, now.day);
    return expiryDate.difference(today).inDays;
  }

  ExpiryBucket? urgencyOn(DateTime now) {
    if (!isOpen) return null;
    final daysLeft = daysLeftFrom(now);
    if (daysLeft < 0) return ExpiryBucket.expired;
    if (daysLeft <= 3) return ExpiryBucket.within3Days;
    if (daysLeft <= 7) return ExpiryBucket.within4To7Days;
    return null;
  }

  int get lossPiasters => quantity * costPricePiasters;

  int get saleValuePiasters => quantity * currentPricePiasters;

  @override
  List<Object?> get props => [
    id,
    productName,
    barcode,
    category,
    quantity,
    costPricePiasters,
    unitPricePiasters,
    discountPricePiasters,
    expiryDate,
    status,
    wasteReason,
    createdAt,
    actionAt,
  ];
}
