# preferences_ui

Create preference screens similar to the android.preference library on Android platforms.

Largely based on [flutter-settings-ui](https://github.com/yako-dev/flutter-settings-ui/), though with support for more kinds of preferences, and more geared toward just Android. This should work on iOS, but I cannot test it, and it will not look native.

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
  categories: [
    PreferenceCategory(
      title: "General",
      preferences: [
        TextPreference(
          title: "Theme",
          summary: "Application theme",
          icon: Icons.settings,
          onTap: () {

          },
        ),
        CheckBoxPreference(
          title: "Block screenshots",
          summaryOn: "Screenshots will be unavailable",
          summaryOff: "Screenshots are available",
          value: checkBoxValue,
          onChanged: (bool value) {
            // Do something with value
          }
        ),
      ],
    ),
  ],
)
```

TODO: Add image of example.

## License
This project is licensed under the MIT license. See [LICENSE](LICENSE) for details.
