import 'package:flutter/material.dart';

import 'package:preferences_ui/preferences_ui.dart';

import 'preferences_helper.dart';
import 'theme_type.dart';
import 'transition_type.dart';

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
    if (newThemeType == _themeType) {
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
  }

  bool _allEnabled = true;
  bool get allEnabled => _allEnabled;
  set allEnabled(bool newAllEnabled) {
    if (newAllEnabled == _allEnabled) {
      return;
    }
    _allEnabled = newAllEnabled;
    notifyListeners();
    _prefs.setAllEnabled(_allEnabled);
  }

  bool _allDense = false;
  bool get allDense => _allDense;
  set allDense(bool newAllDense) {
    if (newAllDense == _allDense) {
      return;
    }
    _allDense = newAllDense;
    notifyListeners();
    _prefs.setAllDense(_allDense);
  }

  double _volume = 50.0;
  double get volume => _volume;
  set volume(double newVolume) {
    if (newVolume == _volume) {
      return;
    }
    _volume = newVolume;
    notifyListeners();
    _prefs.setVolume(_volume);
  }

  bool _remindersEnabled = true;
  bool get remindersEnabled => _remindersEnabled;
  set remindersEnabled(bool newRemindersEnabled) {
    if (newRemindersEnabled == _remindersEnabled) {
      return;
    }
    _remindersEnabled = newRemindersEnabled;
    notifyListeners();
    _prefs.setRemindersEnabled(_remindersEnabled);
  }

  List<bool> _selectedDays = List<bool>.filled(7, false);
  List<bool> get selectedDays => _selectedDays;
  set selectedDays(List<bool> newSelectedDays) {
    if (newSelectedDays == _selectedDays) {
      return;
    }
    _selectedDays = newSelectedDays;
    notifyListeners();
    _prefs.setSelectedDays(_selectedDays);
  }

  TransitionType _transitionType = TransitionType.Default;
  TransitionType get transitionType => _transitionType;
  set transitionType(TransitionType newValue) {
    if (newValue == _transitionType) {
      return;
    }
    _transitionType = newValue;
    notifyListeners();
    _prefs.setTransitionType(_transitionType);

    RouteTransitionsBuilder? transitionsBuilder;
    switch (_transitionType) {
      case TransitionType.Default:
        transitionsBuilder = null;
        break;
      case TransitionType.Fade:
        transitionsBuilder = fadeTransitionsBuilder;
        break;
      case TransitionType.Rotation:
        transitionsBuilder = rotationTransitionsBuilder;
        break;
      case TransitionType.Scale:
        transitionsBuilder = scaleTransitionsBuilder;
        break;
      case TransitionType.Slide:
        transitionsBuilder = slideTransitionsBuilder;
        break;
    }
    preferencePageTransitionsBuilder = transitionsBuilder;
  }

  int _transitionDuration = 0;
  int get transitionDuration => _transitionDuration;
  set transitionDuration(int newValue) {
    if (newValue == _transitionDuration) {
      return;
    }
    _transitionDuration = newValue;
    notifyListeners();
    _prefs.setTransitionDuration(_transitionDuration);
    transitionsSettings = transitionsSettings.copyWith(
      duration: Duration(milliseconds: _transitionDuration),
    );
  }

  int _transitionCurve = 0;
  int get transitionCurve => _transitionCurve;
  set transitionCurve(int newValue) {
    if (newValue == _transitionCurve) {
      return;
    }
    _transitionCurve = newValue;
    notifyListeners();
    _prefs.setTransitionCurve(_transitionCurve);
    transitionsSettings = transitionsSettings.copyWith(
      curve: PreferencesValues.curves[_transitionCurve],
    );
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
    _transitionDuration = await _prefs.getTransitionDuration();
    _transitionCurve = await _prefs.getTransitionCurve();
    // Need to set these directly, so that the changes will be reflected globally.
    transitionsSettings = TransitionsSettings(
      curve: PreferencesValues.curves[_transitionCurve],
      duration: Duration(milliseconds: _transitionDuration),
    );
    // Setting this will call notifyListeners
    transitionType = await _prefs.getTransitionType();
    // notifyListeners();
  }

  void clear() async {
    await _prefs.clear();
    _selectedDays = List<bool>.filled(7, false);
    _initPreferences();
  }
}
