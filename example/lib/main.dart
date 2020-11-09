import 'package:flutter/material.dart';

import 'package:preferences_ui/preferences_ui.dart';

void main() {
  runApp(MyApp());
}

enum Themes {
  Light,
  Dark,
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _allPreferencesDense = false;
  bool _allPreferencesEnabled = true;
  bool _checkBoxValue = false;
  Themes _currentTheme = Themes.Light;
  String _editTextValue = "";
  List<String> _multiSelectEntries = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
  List<bool> _multiSelectValues = List.filled(7, false);
  double _seekBarValue = 50.0;
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _currentTheme == Themes.Light ? ThemeData.light() : ThemeData.dark(),
      child: PreferenceScreen(
        title: "Settings",
        actions: [
          IconButton(
            icon: Icon(_allPreferencesEnabled ? Icons.check : Icons.clear),
            tooltip: "Change enabled property on all preferences",
            onPressed: () {
              setState(() {
                _allPreferencesEnabled = !_allPreferencesEnabled;
              });
            },
          ),
          IconButton(
            icon: Icon(_allPreferencesDense ? Icons.fullscreen_exit : Icons.fullscreen),
            tooltip: "Change dense property on all preferences",
            onPressed: () {
              setState(() {
                _allPreferencesDense = !_allPreferencesDense;
              });
            },
          ),
        ],
        children: [
          PreferenceGroup(
            title: "Two-state preferences",
            children: [
              CheckBoxPreference(
                title: "CheckBox",
                value: _checkBoxValue,
                summaryOn: "This is the summary string when value is true",
                summaryOff: "This is the summary string when value is false",
                onChanged: (value) {
                  setState(() {
                    _checkBoxValue = value;
                  });
                },
                enabled: _allPreferencesEnabled,
                dense: _allPreferencesDense,
              ),
              SwitchPreference(
                title: "Switch",
                summaryOn: "The switch is on",
                summaryOff: "The switch is off",
                value: _switchValue,
                onChanged: (value) {
                  setState(() {
                    _switchValue = value;
                  });
                },
                enabled: _allPreferencesEnabled,
                dense: _allPreferencesDense,
              ),
            ],
          ),
          PreferenceGroup(
            title: "DropDownPreference",
            children: [
              DropDownPreference(
                title: "Application theme (drop down)",
                value: _currentTheme,
                entries: ["Light", "Dark"],
                entryValues: Themes.values,
                onChanged: (theme) {
                  setState(() {
                    _currentTheme = theme;
                  });
                },
                dense: _allPreferencesDense,
                enabled: _allPreferencesEnabled,
              ),
            ],
          ),
          PreferenceGroup(
            title: "EditTextPreference",
            children: [
              EditTextPreference(
                title: "Edit this string",
                value: _editTextValue,
                summary: _editTextValue,
                dialogTitle: "This is a title",
                onChanged: (value) {
                  setState(() {
                    _editTextValue = value;
                  });
                },
                enabled: _allPreferencesEnabled,
                dense: _allPreferencesDense,
              ),
            ],
          ),
          PreferenceGroup(
            title: "ListPreference",
            children: [
              ListPreference(
                title: "Application theme",
                dialogTitle: "Choose a theme",
                value: _currentTheme,
                entries: ["Light", "Dark"],
                entryValues: Themes.values,
                onChanged: (theme) {
                  setState(() {
                    _currentTheme = theme;
                  });
                },
                enabled: _allPreferencesEnabled,
                dense: _allPreferencesDense,
              ),
            ],
          ),
          PreferenceGroup(
            title: "MultiSelectListPreference",
            children: [
              MultiSelectListPreference(
                title: "Days of the week",
                dialogTitle: "Select the days of the week",
                entries: _multiSelectEntries,
                entryValues: _multiSelectValues,
                onChanged: (values) {
                  setState(() {
                    _multiSelectValues = values;
                  });
                },
                formatSummary: (values) {
                  if (!values.any((b) => !b)) {
                    return "All week";
                  }
                  List<String> days = [];
                  for (int i = 0; i < values.length; i++) {
                    if (values[i]) {
                      days.add(_multiSelectEntries[i]);
                    }
                  }
                  if (days.isEmpty) {
                    return "None";
                  }
                  return days.join(", ");
                },
                enabled: _allPreferencesEnabled,
                dense: _allPreferencesDense,
              ),
            ],
          ),
          PreferenceGroup(
            title: "SeekBarPreference",
            children: [
              SeekBarPreference(
                title: "SeekBar",
                value: _seekBarValue,
                showValue: true,
                divisions: 10,
                formatText: (double value) => "$value%",
                onChanged: (value) {
                  setState(() {
                    _seekBarValue = value;
                  });
                },
                enabled: _allPreferencesEnabled,
                dense: _allPreferencesDense,
              ),
            ],
          ),
          PreferencePage(
            title: "About",
            children: [
              Preference(
                title: "Version",
                summary: "0.2.0",
              ),
              Preference(
                title: "Changelog",
              ),
              Preference(
                title: "Licenses",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
