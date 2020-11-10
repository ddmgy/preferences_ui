import 'package:shared_preferences/shared_preferences.dart';

import 'days_of_the_week.dart';
import 'theme_type.dart';
import 'utils.dart';

class PreferencesHelper {
  static final instance = PreferencesHelper._();

  static SharedPreferences _preferences;
  Future<SharedPreferences> get preferences async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
    return _preferences;
  }

  PreferencesHelper._();

  Future<bool> clear() async => (await preferences).clear();

  Future<ThemeType> getTheme() async {
    final prefs = await preferences;
    return (prefs.getInt(PreferencesKeys.theme) ?? 0).toThemeType();
  }

  Future<void> setTheme(ThemeType theme) async {
    final prefs = await preferences;
    prefs.setInt(PreferencesKeys.theme, theme.toInt());
  }

  Future<bool> getAllEnabled() async {
    final prefs = await preferences;
    return prefs.getBool(PreferencesKeys.allEnabled) ?? true;
  }

  Future<void> setAllEnabled(bool allEnabled) async {
    final prefs = await preferences;
    prefs.setBool(PreferencesKeys.allEnabled, allEnabled);
  }

  Future<bool> getAllDense() async {
    final prefs = await preferences;
    return prefs.getBool(PreferencesKeys.allDense) ?? false;
  }

  Future<void> setAllDense(bool allDense) async {
    final prefs = await preferences;
    prefs.setBool(PreferencesKeys.allDense, allDense);
  }

  Future<bool> getRemindersEnabled() async {
    final prefs = await preferences;
    return prefs.getBool(PreferencesKeys.remindersEnabled) ?? true;
  }

  Future<void> setRemindersEnabled(bool remindersEnabled) async {
    final prefs = await preferences;
    prefs.setBool(PreferencesKeys.remindersEnabled, remindersEnabled);
  }

  Future<List<bool>> getSelectedDays() async {
    final prefs = await preferences;
    final result = <bool>[];
    for (final day in DaysOfTheWeek.values) {
      result.add((prefs.getBool(PreferencesKeys.selectedDay(day.toInt())) ?? false));
    }
    return result;
  }

  Future<void> setSelectedDays(List<bool> selectedDays) async {
    final prefs = await preferences;
    selectedDays.forEachIndexed((i, selectedDay) {
      prefs.setBool(PreferencesKeys.selectedDay(i), selectedDay);
    });
  }

  Future<double> getVolume() async {
    final prefs = await preferences;
    return prefs.getDouble(PreferencesKeys.volume) ?? 0.0;
  }

  Future<void> setVolume(double volume) async {
    final prefs = await preferences;
    prefs.setDouble(PreferencesKeys.volume, volume);
  }
}

class PreferencesKeys {
  static String get theme => "theme";

  static String get allEnabled => "all_enabled";

  static String get allDense => "all_dense";

  static String get remindersEnabled => "reminders_enabled";

  static String selectedDay(int day) => "selected_day_$day";

  static String get volume => "volume";
}

class PreferencesValues {
  static List<ThemeType> get themes => ThemeType.values;
}

class PreferencesEntries {
  static List<String> get themes => PreferencesValues.themes.map((themeType) => themeType.name).toList();
}
