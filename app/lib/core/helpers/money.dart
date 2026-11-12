import 'package:easy_localization/easy_localization.dart';

class Money {
  static const int piastersPerPound = 100;
  static const String _arabicDigits = '٠١٢٣٤٥٦٧٨٩';
  static final NumberFormat _number = NumberFormat('#,##0.00', 'en_US');

  static String format(int piasters) =>
      '${formatNumber(piasters)} ${'money.egp'.tr()}';

  static String formatNumber(int piasters) =>
      _number.format(piasters / piastersPerPound);

  static String toInput(int piasters) =>
      (piasters / piastersPerPound).toStringAsFixed(2);

  static int? tryParsePiasters(String input) {
    final normalized = _toLatinDigits(input.trim()).replaceAll(',', '.');
    final pounds = double.tryParse(normalized);
    if (pounds == null) return null;
    return (pounds * piastersPerPound).round();
  }

  static int percentOff(int originalPiasters, int newPiasters) {
    if (originalPiasters <= 0) return 0;
    return ((originalPiasters - newPiasters) * 100 / originalPiasters).round();
  }

  static String _toLatinDigits(String input) {
    final buffer = StringBuffer();
    for (final char in input.split('')) {
      final arabicIndex = _arabicDigits.indexOf(char);
      if (arabicIndex >= 0) {
        buffer.write(arabicIndex);
      } else if (char == '٫') {
        buffer.write('.');
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }
}
