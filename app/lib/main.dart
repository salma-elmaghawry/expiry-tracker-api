import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:expiry_tracker/app.dart';
import 'package:expiry_tracker/core/const/app_assets.dart';
import 'package:expiry_tracker/core/injection/injection_container.dart';
import 'package:expiry_tracker/core/theme/controller/theme_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();
  if (!kIsWeb) {
    await dotenv.load(fileName: AppAssets.env, isOptional: true);
  }
  await setupInjection();

  final savedLocaleCode = getIt<SharedPreferences>().getString('app_locale');
  final startLocale = (savedLocaleCode != null)
      ? Locale(savedLocaleCode)
      : null;

  runApp(
    EasyLocalization(
      startLocale: startLocale,
      fallbackLocale: const Locale('en'),
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: AppAssets.translations,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeCubit>(create: (context) => getIt<ThemeCubit>()),
        ],
        child: const ExpiryTrackerApp(),
      ),
    ),
  );
}
