import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiConfig {
  static const String serverUrlPrefsKey = 'server_url';
  static const int apiPort = 5291;
  static const String _emulatorUrl = 'http://10.0.2.2:5291';

  final SharedPreferences _sharedPreferences;

  ApiConfig(this._sharedPreferences);

  String get baseUrl =>
      _sharedPreferences.getString(serverUrlPrefsKey) ?? defaultBaseUrl;

  String get defaultBaseUrl {
    if (kIsWeb) return 'http://${Uri.base.host}:$apiPort';
    return dotenv.env['API_BASE_URL'] ?? _emulatorUrl;
  }
}
