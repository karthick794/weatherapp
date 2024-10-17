import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static const String keyTemperatureUnit = 'temperature_unit';

  Future<void> setPreferredUnit(String unit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyTemperatureUnit, unit);
  }

  Future<String?> getPreferredUnit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyTemperatureUnit) ?? 'C'; // Default to Celsius
  }
}
