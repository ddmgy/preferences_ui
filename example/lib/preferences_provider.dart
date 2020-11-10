import 'package:flutter/material.dart';

import 'preferences_helper.dart';
import 'theme_type.dart';

ThemeData _lightTheme = ThemeData(
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

ThemeData _darkTheme = ThemeData(
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

class PreferencesProvider extends ChangeNotifier {
  final _prefs = PreferencesHelper.instance;

  ThemeType _themeType = ThemeType.Light;
  ThemeType get themeType => _themeType;
  set themeType(ThemeType newThemeType) {
    if (newThemeType == _themeType || newThemeType == null) {
      return;
    }
    _themeType = newThemeType;
    notifyListeners();
    _prefs.setTheme(_themeType);
  }

  ThemeData get theme {
    switch (_themeType) {
      case ThemeType.Light:
        return _lightTheme;
      case ThemeType.Dark:
        return _darkTheme;
    }
    throw Exception("unreachable");
  }

  bool _allEnabled = false;
  bool get allEnabled => _allEnabled;
  set allEnabled(bool newAllEnabled) {
    if (newAllEnabled == _allEnabled || newAllEnabled == null) {
      return;
    }
    _allEnabled = newAllEnabled;
    notifyListeners();
    _prefs.setAllEnabled(_allEnabled);
  }

  bool _allDense = false;
  bool get allDense => _allDense;
  set allDense(bool newAllDense) {
    if (newAllDense == _allDense || newAllDense == null) {
      return;
    }
    _allDense = newAllDense;
    notifyListeners();
    _prefs.setAllDense(_allDense);
  }

  double _volume = 50.0;
  double get volume => _volume;
  set volume(double newVolume) {
    if (newVolume == _volume || newVolume == null) {
      return;
    }
    _volume = newVolume;
    notifyListeners();
    _prefs.setVolume(_volume);
  }

  bool _remindersEnabled = true;
  bool get remindersEnabled => _remindersEnabled;
  set remindersEnabled(bool newRemindersEnabled) {
    if (newRemindersEnabled == _remindersEnabled || newRemindersEnabled == null) {
      return;
    }
    _remindersEnabled = newRemindersEnabled;
    notifyListeners();
    _prefs.setRemindersEnabled(_remindersEnabled);
  }

  List<bool> _selectedDays = List<bool>.filled(7, false);
  List<bool> get selectedDays => _selectedDays;
  set selectedDays(List<bool> newSelectedDays) {
    if (newSelectedDays == _selectedDays || newSelectedDays == null) {
      return;
    }
    _selectedDays = newSelectedDays;
    notifyListeners();
    _prefs.setSelectedDays(_selectedDays);
  }

  PreferencesProvider() {
    _initPreferences();
  }

  void _initPreferences() async {
    _themeType = await _prefs.getTheme();
    _allEnabled = await _prefs.getAllEnabled();
    _allDense = await _prefs.getAllDense();
    _volume = await _prefs.getVolume();
    _remindersEnabled = await _prefs.getRemindersEnabled();
    _selectedDays = await _prefs.getSelectedDays();
    notifyListeners();
  }

  void clear() async {
    await _prefs.clear();
    _selectedDays = List<bool>.filled(7, false);
    _initPreferences();
  }
}
