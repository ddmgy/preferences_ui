# preferences_ui

Create preference screens similar to the android.preference library on Android platforms.

Initially based on [flutter-settings-ui](https://github.com/yako-dev/flutter-settings-ui/), but with support for more preferences and more geared toward Android. Should work on all platforms, but I can only test on Android, Linux, and Windows.

## Installing:

In pubspec.yaml:

```yaml
dependencies:
  preferences_ui:
    git:
      url: git://github.com/ddmgy/preferences_ui.git
      ref: master
```

In dart file:
```dart
import 'package:preferences_ui/preferences_ui.dart';
```

## Usage:

```dart
PreferenceScreen(
  title: "Settings",
  children: [
    PreferenceGroup(
      title: "General",
      children: [
        ListPreference<Themes>(
          title: "Application theme",
          dialogTitle: "Choose a theme",
          value: currentTheme,
          entries: ["Light", "Dark"],
          entryValues: [Themes.Light, Themes.Dark],
          onChanged: (Themes newTheme) {
            setState(() {
              currentTheme = newTheme;
            });
          },
        ),
        CheckBoxPreference(
          title: "Block screenshots",
          summaryOn: "Screenshots will be unavailable",
          summaryOff: "Screenshots are available",
          value: checkBoxValue,
          onChanged: (bool value) {
            setState(() {
              checkBoxValue = value;
            });
          },
        ),
      ],
    ),
  ],
)
```

TODO: Add image of example.

## License
This project is licensed under the MIT license. See [LICENSE](LICENSE) for details.
