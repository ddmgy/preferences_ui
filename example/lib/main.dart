import 'package:flutter/material.dart';

import 'package:preferences_ui/preferences_ui.dart';
import 'package:provider/provider.dart';

import 'days_of_the_week.dart';
import 'preferences_helper.dart';
import 'preferences_provider.dart';
import 'theme_type.dart';
import 'utils.dart';

void main() {
  runApp(
    ChangeNotifierProvider<PreferencesProvider>(
      create: (_) => PreferencesProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Selector<PreferencesProvider, ThemeData>(
    selector: (_, provider) => provider.theme,
    builder: (context, theme, _) => MaterialApp(
      title: "preferences_ui example",
      theme: theme,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    ),
  );
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Consumer<PreferencesProvider>(
    builder: (context, provider, _) {
      final allDense = provider.allDense;
      final allEnabled = provider.allEnabled;

      return PreferenceScreen(
        title: "Settings",
        actions: [
          IconButton(
            icon: Icon(allEnabled ? Icons.check : Icons.clear),
            tooltip: "Change enabled property on all preferences",
            onPressed: () {
              provider.allEnabled = !allEnabled;
            },
          ),
          IconButton(
            icon: Icon(allDense ? Icons.fullscreen_exit : Icons.fullscreen),
            tooltip: "Change dense property on all preferences",
            onPressed: () {
              provider.allDense = !allDense;
            },
          ),
        ],
        children: [
          PreferenceGroup(
            title: "General",
            children: [
              ListPreference(
                title: "Application theme",
                dialogTitle: "Choose a theme",
                value: provider.themeType,
                entries: PreferencesEntries.themes,
                entryValues: PreferencesValues.themes,
                onChanged: (ThemeType themeType) {
                  provider.themeType = themeType;
                },
                enabled: allEnabled,
                dense: allDense,
              ),
              DropDownPreference(
                title: "Application theme (drop down)",
                value: provider.themeType,
                entries: PreferencesEntries.themes,
                entryValues: PreferencesValues.themes,
                onChanged: (ThemeType themeType) {
                  provider.themeType = themeType;
                },
                enabled: allEnabled,
                dense: allDense,
              ),
              SeekBarPreference(
                title: "Volume",
                value: provider.volume,
                leading: Icon(Icons.volume_up),
                min: 0,
                max: 100,
                showValue: true,
                formatText: (double value) => "${value.toStringAsPrecision(4)}%",
                onChanged: (double value) {
                  provider.volume = value;
                },
                enabled: allEnabled,
                dense: allDense,
              ),
            ],
          ),
          PreferenceGroup(
            title: "Reminders",
            children: [
              CheckBoxPreference(
                title: "Enable reminders",
                value: provider.remindersEnabled,
                summaryOn: "The user will receive reminders",
                summaryOff: "The user will not receive any reminders",
                onChanged: (bool value) {
                  provider.remindersEnabled = value;
                },
                enabled: allEnabled,
                dense: allDense,
              ),
              MultiSelectListPreference(
                title: "Days to alert user",
                dialogTitle: "Select the days of the week",
                leading: Icon(Icons.calendar_today),
                entries: DaysOfTheWeek.values.map((day) => day.name).toList(),
                entryValues: provider.selectedDays,
                onChanged: (List<bool> values) {
                  provider.selectedDays = values;
                },
                formatSummary: (List<bool> values) {
                  if (!values.any((b) => !b)) {
                    return "All week";
                  }
                  final days = <String>[];
                  for (int i = 0; i < values.length; i++) {
                    if (values[i]) {
                      days.add(i.toDaysOfTheWeek().name);
                    }
                  }
                  if (days.isEmpty) {
                    return "None";
                  }
                  return days.join(", ");
                },
                enabled: provider.remindersEnabled,
                dense: allDense,
              ),
            ],
          ),
          PreferenceGroup(
            title: "Advanced",
            children: [
              PreferencePage(
                title: "About",
                summary: "Information about this application",
                leading: Icon(Icons.info),
                children: [
                  Preference(
                    title: "Version",
                    summary: "0.2.0",
                    enabled: allEnabled,
                    dense: allDense,
                  ),
                  Preference(
                    title: "Changelog",
                    enabled: allEnabled,
                    dense: allDense,
                  ),
                  Preference(
                    title: "Licenses",
                    enabled: allEnabled,
                    dense: allDense,
                  ),
                ],
                enabled: allEnabled,
                dense: allDense,
              ),
              Preference(
                title: "Reset user preferences",
                leading: Icon(Icons.code),
                onLongPress: () {
                  provider.clear();
                },
                dense: allDense,
              ),
            ],
          ),
        ],
      );
    },
  );
}

// class _HomeScreenState extends State<HomeScreen> {
//   bool _allPreferencesDense = false;
//   bool _allPreferencesEnabled = true;
//   bool _checkBoxValue = false;
//   Themes _currentTheme = Themes.Light;
//   String _editTextValue = "";
//   List<String> _multiSelectEntries = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
//   List<bool> _multiSelectValues = List.filled(7, false);
//   double _seekBarValue = 50.0;
//   bool _switchValue = false;

//   @override
//   Widget build(BuildContext context) {
//     return Theme(
//       data: _currentTheme == Themes.Light ? ThemeData.light() : ThemeData.dark(),
//       child: PreferenceScreen(
//         children: [
//           PreferenceGroup(
//             title: "Two-state preferences",
//             children: [
//               CheckBoxPreference(
//                 title: "CheckBox",
//                 value: _checkBoxValue,
//                 summaryOn: "This is the summary string when value is true",
//                 summaryOff: "This is the summary string when value is false",
//                 onChanged: (value) {
//                   setState(() {
//                     _checkBoxValue = value;
//                   });
//                 },
//                 enabled: _allPreferencesEnabled,
//                 dense: _allPreferencesDense,
//               ),
//               SwitchPreference(
//                 title: "Switch",
//                 summaryOn: "The switch is on",
//                 summaryOff: "The switch is off",
//                 value: _switchValue,
//                 onChanged: (value) {
//                   setState(() {
//                     _switchValue = value;
//                   });
//                 },
//                 enabled: _allPreferencesEnabled,
//                 dense: _allPreferencesDense,
//               ),
//             ],
//           ),
//           PreferenceGroup(
//             title: "DropDownPreference",
//             children: [
//               DropDownPreference(
//                 title: "Application theme (drop down)",
//                 value: _currentTheme,
//                 entries: ["Light", "Dark"],
//                 entryValues: Themes.values,
//                 onChanged: (theme) {
//                   setState(() {
//                     _currentTheme = theme;
//                   });
//                 },
//                 dense: _allPreferencesDense,
//                 enabled: _allPreferencesEnabled,
//               ),
//             ],
//           ),
//           PreferenceGroup(
//             title: "EditTextPreference",
//             children: [
//               EditTextPreference(
//                 title: "Edit this string",
//                 value: _editTextValue,
//                 summary: _editTextValue,
//                 dialogTitle: "This is a title",
//                 onChanged: (value) {
//                   setState(() {
//                     _editTextValue = value;
//                   });
//                 },
//                 enabled: _allPreferencesEnabled,
//                 dense: _allPreferencesDense,
//               ),
//             ],
//           ),
//           PreferenceGroup(
//             title: "ListPreference",
//             children: [
//               ListPreference(
//                 title: "Application theme",
//                 dialogTitle: "Choose a theme",
//                 value: _currentTheme,
//                 entries: ["Light", "Dark"],
//                 entryValues: Themes.values,
//                 onChanged: (theme) {
//                   setState(() {
//                     _currentTheme = theme;
//                   });
//                 },
//                 enabled: _allPreferencesEnabled,
//                 dense: _allPreferencesDense,
//               ),
//             ],
//           ),
//           PreferenceGroup(
//             title: "MultiSelectListPreference",
//             children: [
//               MultiSelectListPreference(
//                 title: "Days of the week",
//                 dialogTitle: "Select the days of the week",
//                 entries: _multiSelectEntries,
//                 entryValues: _multiSelectValues,
//                 onChanged: (values) {
//                   setState(() {
//                     _multiSelectValues = values;
//                   });
//                 },
//                 formatSummary: (values) {
//                   if (!values.any((b) => !b)) {
//                     return "All week";
//                   }
//                   List<String> days = [];
//                   for (int i = 0; i < values.length; i++) {
//                     if (values[i]) {
//                       days.add(_multiSelectEntries[i]);
//                     }
//                   }
//                   if (days.isEmpty) {
//                     return "None";
//                   }
//                   return days.join(", ");
//                 },
//                 enabled: _allPreferencesEnabled,
//                 dense: _allPreferencesDense,
//               ),
//             ],
//           ),
//           PreferenceGroup(
//             title: "SeekBarPreference",
//             children: [
//               SeekBarPreference(
//                 title: "SeekBar",
//                 value: _seekBarValue,
//                 showValue: true,
//                 divisions: 10,
//                 formatText: (double value) => "$value%",
//                 onChanged: (value) {
//                   setState(() {
//                     _seekBarValue = value;
//                   });
//                 },
//                 enabled: _allPreferencesEnabled,
//                 dense: _allPreferencesDense,
//               ),
//             ],
//           ),
//           PreferencePage(
//             title: "About",
//             children: [
//               Preference(
//                 title: "Version",
//                 summary: "0.2.0",
//               ),
//               Preference(
//                 title: "Changelog",
//               ),
//               Preference(
//                 title: "Licenses",
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
