import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/money.dart';

class AppValidators {
  static String? validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'validation.required'.tr();
    }
    return null;
  }

  static String? validatePrice(String? value) {
    final requiredError = validateRequired(value);
    if (requiredError != null) return requiredError;

    final piasters = Money.tryParsePiasters(value!);
    if (piasters == null) return 'validation.invalid_price'.tr();
    if (piasters <= 0) return 'validation.price_positive'.tr();
    return null;
  }
}
