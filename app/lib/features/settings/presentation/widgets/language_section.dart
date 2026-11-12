import 'package:easy_localization/easy_localization.dart';
import 'package:expiry_tracker/core/helpers/spacing.dart';
import 'package:expiry_tracker/core/injection/injection_container.dart';
import 'package:expiry_tracker/core/utils/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSection extends StatelessWidget {
  const LanguageSection({super.key});

  static const String _localePrefsKey = 'app_locale';

  Future<void> _changeLanguage(
    BuildContext context,
    String languageCode,
  ) async {
    await context.setLocale(Locale(languageCode));
    await getIt<SharedPreferences>().setString(_localePrefsKey, languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('settings.language'.tr(), style: AppTextStyles.font16SemiBold),
        verticalSpace(8),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(
              value: 'en',
              label: Text('settings.language_en'.tr()),
            ),
            ButtonSegment(
              value: 'ar',
              label: Text('settings.language_ar'.tr()),
            ),
          ],
          selected: {context.locale.languageCode},
          onSelectionChanged: (selection) =>
              _changeLanguage(context, selection.first),
        ),
      ],
    );
  }
}
