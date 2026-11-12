import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

class AppDateFormatter {
  static String short(DateTime date, Locale locale) {
    final month = DateFormat.MMMM(locale.languageCode).format(date);
    if (locale.languageCode == 'ar') return '${date.day} $month ${date.year}';
    return DateFormat('d MMM y', 'en').format(date);
  }
}
