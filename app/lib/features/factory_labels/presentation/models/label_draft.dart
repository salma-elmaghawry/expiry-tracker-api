import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/domain/api_enum.dart';
import 'package:expiry_tracker/core/domain/enums/category.dart';
import 'package:expiry_tracker/core/helpers/money.dart';
import 'package:expiry_tracker/features/factory_labels/domain/usecases/create_label_job_usecase.dart';
import 'package:expiry_tracker/features/factory_labels/presentation/widgets/carton_label_card.dart';

/// The label form as typed, turned into numbers, errors and preview data.
/// Pure Dart (no widgets), so the rules are easy to read and to test.
class LabelDraft {
  static const int maxCartons = 1000; // same limit as the API

  final String name;
  final String barcode;
  final Category category;
  final String boxesText;
  final String perBoxText;
  final String lot;
  final DateTime? productionDate;
  final DateTime? expiryDate;
  final String costText;
  final String countText;

  const LabelDraft({
    required this.name,
    required this.barcode,
    required this.category,
    required this.boxesText,
    required this.perBoxText,
    required this.lot,
    required this.productionDate,
    required this.expiryDate,
    required this.costText,
    required this.countText,
  });

  int? get boxes => int.tryParse(boxesText.trim());
  int? get perBox => int.tryParse(perBoxText.trim());
  int? get count => int.tryParse(countText.trim());
  int? get costPiasters => Money.tryParsePiasters(costText);

  int get piecesPerCarton => (boxes ?? 0) * (perBox ?? 0);

  // ---- Errors to show under each field. Empty fields show nothing (the button stays disabled),
  //      so a fresh form is not covered in red.

  String? get barcodeError =>
      barcode.trim().isNotEmpty && !RegExp(r'^\d+$').hasMatch(barcode.trim())
      ? 'factory.errors.barcode_digits'.tr()
      : null;

  String? get boxesError => _positiveIntError(boxesText);
  String? get perBoxError => _positiveIntError(perBoxText);

  String? get countError {
    final error = _positiveIntError(countText);
    if (error != null) return error;
    if ((count ?? 0) > maxCartons) {
      return 'factory.errors.max_cartons'.tr(args: ['$maxCartons']);
    }
    return null;
  }

  String? get costError {
    if (costText.trim().isEmpty) return null;
    final piasters = costPiasters;
    if (piasters == null) return 'validation.invalid_price'.tr();
    if (piasters <= 0) return 'factory.errors.above_zero'.tr();
    return null;
  }

  String? get expiryError {
    final mfg = productionDate, exp = expiryDate;
    if (mfg == null || exp == null || exp.isAfter(mfg)) return null;
    return 'factory.errors.expiry_after_production'.tr();
  }

  String? _positiveIntError(String text) {
    if (text.trim().isEmpty) return null;
    final value = int.tryParse(text.trim());
    if (value == null) return 'factory.errors.whole_number'.tr();
    if (value <= 0) return 'factory.errors.above_zero'.tr();
    return null;
  }

  /// Everything filled in and valid: the print button can be pressed.
  bool get isComplete =>
      name.trim().isNotEmpty &&
      barcode.trim().isNotEmpty &&
      lot.trim().isNotEmpty &&
      boxesText.trim().isNotEmpty &&
      perBoxText.trim().isNotEmpty &&
      costText.trim().isNotEmpty &&
      countText.trim().isNotEmpty &&
      productionDate != null &&
      expiryDate != null &&
      barcodeError == null &&
      boxesError == null &&
      perBoxError == null &&
      costError == null &&
      countError == null &&
      expiryError == null;

  /// Only call when [isComplete] is true.
  CreateLabelJobParams toParams() => CreateLabelJobParams(
    productName: name.trim(),
    barcode: barcode.trim(),
    category: category,
    boxesCount: boxes!,
    piecesPerBox: perBox!,
    lotNumber: lot.trim(),
    productionDate: productionDate!,
    expiryDate: expiryDate!,
    costPiasters: costPiasters!,
    cartonCount: count!,
  );

  // ---- Live preview of label number 1.

  /// Same rule as the server: "ED-2611-07" -> "CT-ED261107-0001".
  String get firstCartonCode {
    final clean = lot.toUpperCase().replaceAll(RegExp('[^A-Z0-9]'), '');
    final prefix = clean.length > 12 ? clean.substring(0, 12) : clean;
    return 'CT-${prefix.isEmpty ? 'LOT' : prefix}-0001';
  }

  /// A sample of what the QR will hold, WITHOUT the signature: the real, signed
  /// text only exists after the server creates the labels.
  String get sampleQrText {
    final format = DateFormat('yyyy-MM-dd');
    return jsonEncode({
      'v': 1,
      'id': firstCartonCode,
      'barcode': barcode.trim(),
      'name': name.trim(),
      'category': category.apiName,
      'boxes': boxes ?? 0,
      'perBox': perBox ?? 0,
      'lot': lot.trim(),
      'mfg': productionDate == null ? '' : format.format(productionDate!),
      'exp': expiryDate == null ? '' : format.format(expiryDate!),
      'cost': costPiasters ?? 0,
    });
  }

  CartonLabelData get previewLabel => CartonLabelData(
    cartonCode: firstCartonCode,
    qrText: sampleQrText,
    productName: name.trim(),
    lotNumber: lot.trim(),
    productionDate: productionDate,
    expiryDate: expiryDate,
    boxesCount: boxes ?? 0,
    piecesPerBox: perBox ?? 0,
  );
}
