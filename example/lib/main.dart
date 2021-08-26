import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:preferences_ui/preferences_ui.dart';
import 'package:provider/provider.dart';

import 'days_of_the_week.dart';
import 'preferences_helper.dart';
import 'preferences_provider.dart';
import 'theme_type.dart';
import 'transition_type.dart';

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
              PreferencePage(
                title: 'Application theme (page)',
                summary: provider.themeType.name,
                children: [
                  ListPreference(
                    title: 'Application theme',
                    dialogTitle: 'Choose a theme',
                    value: provider.themeType,
                    entries: PreferencesEntries.themes,
                    entryValues: PreferencesValues.themes,
                    onChanged: (ThemeType themeType) {
                      provider.themeType = themeType;
                    },
                    enabled: allEnabled,
                    dense: allDense,
                  ),
                ],
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
            title: "Transitions",
            children: [
              ListPreference(
                title: "Type",
                dialogTitle: "Choose a transition type",
                value: provider.transitionType,
                entries: PreferencesEntries.transitionTypes,
                entryValues: PreferencesValues.transitionTypes,
                onChanged: (TransitionType transitionType) {
                  provider.transitionType = transitionType;
                },
                enabled: allEnabled,
                dense: allDense,
              ),
              SeekBarPreference(
                title: "Duration",
                value: provider.transitionDuration.toDouble(),
                min: 0,
                max: 500,
                divisions: 10,
                showValue: true,
                formatText: (double value) => "${value.toInt().toString()}ms",
                onChanged: (double newValue) {
                  provider.transitionDuration = newValue.toInt();
                },
                enabled: allEnabled,
                dense: allDense,
              ),
              ListPreference(
                title: "Curve",
                dialogTitle: "Choose a curve",
                value: PreferencesValues.curves[provider.transitionCurve],
                entries: PreferencesEntries.curves,
                entryValues: PreferencesValues.curves,
                onChanged: (Curve newValue) {
                  provider.transitionCurve = PreferencesValues.curves.indexOf(newValue);
                },
                enabled: allEnabled,
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
                    summary: "0.3.0",
                    onTap: () {},
                    enabled: allEnabled,
                    dense: allDense,
                  ),
                  Preference(
                    title: "Changelog",
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => _ChangelogScreen(),
                      ));
                    },
                    enabled: allEnabled,
                    dense: allDense,
                  ),
                  Preference(
                    title: "Licenses",
                    onTap: () {
                      showLicensePage(
                        context: context,
                        applicationName: "preferences_ui example",
                        applicationVersion: "0.3.0",
                        applicationLegalese: "© 2020 David Mougey",
                      );
                    },
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

class _ChangelogScreen extends StatefulWidget {
  Future<String> get data async =>
    rootBundle.loadString("CHANGELOG.md");

  @override
  State<StatefulWidget> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<_ChangelogScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Changelog"),
      ),
      body: Center(
        child: FutureBuilder<String>(
          future: widget.data,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error as String),
              );
            }

            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Scrollbar(
              child: Markdown(
                data: snapshot.data!,
              ),
            );
          },
        ),
      ),
    );
  }
}
