import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/domain/expiry.dart';
import 'package:expiry_tracker/features/factory_labels/domain/entities/label_job.dart';

class LabelJobModel {
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
  final int costPiasters;
  final int cartonCount;
  final List<CartonLabel> labels;

  const LabelJobModel({
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

  factory LabelJobModel.fromJson(Map<String, dynamic> json) {
    return LabelJobModel(
      id: json['id'] as int,
      productName: json['productName'] as String,
      barcode: json['barcode'] as String,
      category: enumFromApi(Category.values, json['category'] as String),
      boxesCount: json['boxesCount'] as int,
      piecesPerBox: json['piecesPerBox'] as int,
      piecesPerCarton: json['piecesPerCarton'] as int,
      lotNumber: json['lotNumber'] as String,
      productionDate: parseCalendarDate(json['productionDate'] as String),
      expiryDate: parseCalendarDate(json['expiryDate'] as String),
      costPiasters: json['costPiasters'] as int,
      cartonCount: json['cartonCount'] as int,
      labels: [
        for (final label in json['labels'] as List)
          CartonLabel(
            cartonCode: (label as Map<String, dynamic>)['cartonCode'] as String,
            qrText: label['qrText'] as String,
          ),
      ],
    );
  }

  LabelJob toEntity() {
    return LabelJob(
      id: id,
      productName: productName,
      barcode: barcode,
      category: category,
      boxesCount: boxesCount,
      piecesPerBox: piecesPerBox,
      piecesPerCarton: piecesPerCarton,
      lotNumber: lotNumber,
      productionDate: productionDate,
      expiryDate: expiryDate,
      costPiasters: costPiasters,
      cartonCount: cartonCount,
      labels: labels,
    );
  }
}
