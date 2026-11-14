import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

/// What one printed label shows. Shared by the live preview and the print pages.
class CartonLabelData {
  final String cartonCode;
  final String qrText;
  final String productName;
  final String lotNumber;
  final DateTime? productionDate;
  final DateTime? expiryDate;
  final int boxesCount;
  final int piecesPerBox;

  const CartonLabelData({
    required this.cartonCode,
    required this.qrText,
    required this.productName,
    required this.lotNumber,
    required this.productionDate,
    required this.expiryDate,
    required this.boxesCount,
    required this.piecesPerBox,
  });
}

/// The sticker itself: 100 x 60 mm = 378 x 227 logical pixels at 96 dpi.
///
/// Sizes are plain pixels (no .w / .sp) on purpose: this is a physical label,
/// it must not grow or shrink with the window. Wrap it in a FittedBox to show it smaller.
/// Always white with black ink and left-to-right, even in dark mode or Arabic,
/// because that is what comes out of the printer.
class CartonLabelCard extends StatelessWidget {
  static const double width = 378;
  static const double height = 227;

  final CartonLabelData data;
  final bool elevated;

  const CartonLabelCard({super.key, required this.data, this.elevated = true});

  static const Color _ink = Color(0xFF111111);

  // "01 NOV 2026", in English on every label so any store can read it.
  static String _date(DateTime? date) => date == null
      ? '--'
      : DateFormat('dd MMM yyyy', 'en').format(date).toUpperCase();

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(
      context,
    ).textTheme.bodyMedium!.copyWith(color: _ink, height: 1.2);
    final name = data.productName.isEmpty ? '-' : data.productName;
    final lot = data.lotNumber.isEmpty ? '-' : data.lotNumber;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: width,
        height: height,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(elevated ? 6 : 0),
          boxShadow: elevated
              ? const [
                  BoxShadow(
                    color: Color(0x2E000000),
                    blurRadius: 20,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                QrImageView(
                  data: data.qrText,
                  size: 150,
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.white,
                  eyeStyle: const QrEyeStyle(
                    eyeShape: QrEyeShape.square,
                    color: _ink,
                  ),
                  dataModuleStyle: const QrDataModuleStyle(
                    dataModuleShape: QrDataModuleShape.square,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  data.cartonCode,
                  style: base.copyWith(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: base.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'LOT $lot',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: base.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    'MFG ${_date(data.productionDate)}',
                    style: base.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  // Expiry is the one thing store staff look for: white on black.
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _ink,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      'EXP ${_date(data.expiryDate)}',
                      style: base.copyWith(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${data.boxesCount} x ${data.piecesPerBox} pcs',
                    style: base.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
