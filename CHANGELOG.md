# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and the project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Fixed
 - Add export for TransitionsSettings.

## [0.5.0] - 2020-11-20
### Added
 - Add a way to globally configure transitions between pages while in a PreferenceScreen.

## [0.4.0] - 2020-11-10
### Added
 - Add PreferencePage, to create sub-menus for settings.
 - Add CHANGELOG.md and LICENSE to example, can be viewed in example application.
### Changed
 - Rewrite preferences again. Usages will need to be updated, but the transition should be easy enough.
 - Rewrite example to reflect changes in library.
 - Add Preference.getBottomWidget, so bottom widget will automatically react to theme changes.
 - Update example to show a more complete way of how using preferences_ui with SharedPreferences.

## [0.3.0] - 2020-10-31
### Added
 - Add Linux and Windows to example.
### Fixed
 - Change List/MultiSelectListPreference, which previously did not work on Windows (possibly other desktop environments, as well).

## [0.2.2] - 2020-07-27
### Fixed
 - Add skrinkWrap property to ListViews in List/MultiSelectListPreference, so that dialogs do not inflate to fill vertical screen space.

## [0.2.1] - 2020-06-30
### Added
 - Add DropDownPreference, to quickly select from a few options.

## [0.2.0] - 2020-06-27
### Added
 - Basic example of how to use this library.
### Changed
 - Completely rewrite preferences internally. Usage is largely unchanged.

## [0.1.1] - 2020-05-09
### Added
 - Add explanation of origin of this library.

## [0.1.0] - 2020-05-09
### Added
 - Initial release. Create screens to manage application preferences/settings.
