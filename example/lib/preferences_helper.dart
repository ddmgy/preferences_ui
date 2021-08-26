import 'package:flutter/widgets.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'days_of_the_week.dart';
import 'theme_type.dart';
import 'transition_type.dart';
import 'utils.dart';

class PreferencesHelper {
  static final instance = PreferencesHelper._();

  Future<SharedPreferences> get preferences async => await SharedPreferences.getInstance();

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

  Future<TransitionType> getTransitionType() async {
    final prefs = await preferences;
    return (prefs.getInt(PreferencesKeys.transitionType) ?? 0).toTransitionType();
  }

  Future<void> setTransitionType(TransitionType transitionType) async {
    final prefs = await preferences;
    prefs.setInt(PreferencesKeys.transitionType, transitionType.toInt());
  }

  Future<int> getTransitionDuration() async {
    final prefs = await preferences;
    return prefs.getInt(PreferencesKeys.transitionDuration) ?? 0;
  }

  Future<void> setTransitionDuration(int transitionDuration) async {
    final prefs = await preferences;
    prefs.setInt(PreferencesKeys.transitionDuration, transitionDuration);
  }

  Future<int> getTransitionCurve() async {
    final prefs = await preferences;
    return prefs.getInt(PreferencesKeys.transitionCurve) ?? 0;
  }

  Future<void> setTransitionCurve(int transitionCurve) async {
    final prefs = await preferences;
    prefs.setInt(PreferencesKeys.transitionCurve, transitionCurve);
  }
}

class PreferencesKeys {
  static String get theme => "theme";

  static String get allEnabled => "all_enabled";

  static String get allDense => "all_dense";

  static String get remindersEnabled => "reminders_enabled";

  static String selectedDay(int day) => "selected_day_$day";

  static String get volume => "volume";

  static String get transitionType => "transition_type";

  static String get transitionDuration => "transition_duration";

  static String get transitionCurve => "transition_curve";
}

class PreferencesValues {
  static List<ThemeType> get themes => ThemeType.values;

  static List<TransitionType> get transitionTypes => TransitionType.values;

  static List<Curve> get curves => _curves;
}

class PreferencesEntries {
  static List<String> get themes => PreferencesValues.themes.map((themeType) => themeType.name).toList();

  static List<String> get transitionTypes => PreferencesValues.transitionTypes.map((transitionType) => transitionType.name).toList();

  static List<String> get curves => _curveNames;
}

const _curves = [
  Curves.linear,
  Curves.bounceIn,
  Curves.bounceInOut,
  Curves.bounceOut,
  Curves.decelerate,
  Curves.ease,
  Curves.easeIn,
  Curves.easeInBack,
  Curves.easeInCirc,
  Curves.easeInCubic,
  Curves.easeInExpo,
  Curves.easeInOut,
  Curves.easeInOutBack,
  Curves.easeInOutCirc,
  Curves.easeInOutCubic,
  Curves.easeInOutExpo,
  Curves.easeInOutQuad,
  Curves.easeInOutQuart,
  Curves.easeInOutQuint,
  Curves.easeInOutSine,
  Curves.easeInQuad,
  Curves.easeInQuart,
  Curves.easeInQuint,
  Curves.easeInSine,
  Curves.easeInToLinear,
  Curves.easeOut,
  Curves.easeOutBack,
  Curves.easeOutCirc,
  Curves.easeOutCubic,
  Curves.easeOutExpo,
  Curves.easeOutQuad,
  Curves.easeOutQuart,
  Curves.easeOutQuint,
  Curves.easeOutSine,
  Curves.elasticIn,
  Curves.elasticInOut,
  Curves.elasticOut,
  Curves.fastLinearToSlowEaseIn,
  Curves.fastOutSlowIn,
  Curves.linearToEaseOut,
  Curves.slowMiddle,
];

const _curveNames = [
  "Curves.linear",
  "Curves.bounceIn",
  "Curves.bounceInOut",
  "Curves.bounceOut",
  "Curves.decelerate",
  "Curves.ease",
  "Curves.easeIn",
  "Curves.easeInBack",
  "Curves.easeInCirc",
  "Curves.easeInCubic",
  "Curves.easeInExpo",
  "Curves.easeInOut",
  "Curves.easeInOutBack",
  "Curves.easeInOutCirc",
  "Curves.easeInOutCubic",
  "Curves.easeInOutExpo",
  "Curves.easeInOutQuad",
  "Curves.easeInOutQuart",
  "Curves.easeInOutQuint",
  "Curves.easeInOutSine",
  "Curves.easeInQuad",
  "Curves.easeInQuart",
  "Curves.easeInQuint",
  "Curves.easeInSine",
  "Curves.easeInToLinear",
  "Curves.easeOut",
  "Curves.easeOutBack",
  "Curves.easeOutCirc",
  "Curves.easeOutCubic",
  "Curves.easeOutExpo",
  "Curves.easeOutQuad",
  "Curves.easeOutQuart",
  "Curves.easeOutQuint",
  "Curves.easeOutSine",
  "Curves.elasticIn",
  "Curves.elasticInOut",
  "Curves.elasticOut",
  "Curves.fastLinearToSlowEaseIn",
  "Curves.fastOutSlowIn",
  "Curves.linearToEaseOut",
  "Curves.slowMiddle",
];
