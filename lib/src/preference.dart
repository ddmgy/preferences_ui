import 'package:flutter/material.dart';

abstract class Preference extends StatelessWidget {
  final String title;
  final String summary;
  final bool enabled;
  final bool dense;
  final Color iconColor;
  final Widget leading;
  final Widget trailing;
  final Widget bottom;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  Preference({
    Key key,
    @required this.title,
    this.summary,
    this.iconColor,
    this.leading,
    this.trailing,
    this.bottom,
    this.onTap,
    this.onLongPress,
    this.dense,
    this.enabled = true,
  }) : super(key: key);

  /// Get the widget that sits on the leading edge (start) of Preference widget.
  /// Will most often be an icon, but subclasses amy choose to replace with any kind of widget.
  Widget _leading(ThemeData theme) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: leading,
    );
  }

  /// Get the widget that sits at the trailing edge (end) of Preference widget.
  /// i.e., a Checkbox, a Switch, an icon to show navigation to deeper depth.
  Widget _trailing(ThemeData theme) {
    return Container(
      height: 24,
      alignment: Alignment.center,
      child: trailing,
    );
  }

  String _summary() => summary;

  Color _iconColor(ThemeData theme) {
    if (!enabled) {
      return theme.disabledColor;
    }

    if (iconColor != null) {
      return iconColor;
    }

    assert(theme.brightness != null);
    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black87;
      case Brightness.dark:
        return null;
    }

    return null;
  }

  Color _textColor(ThemeData theme) {
    if (!enabled) {
      return theme.disabledColor;
    }

    assert(theme.brightness != null);
    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black87;
      case Brightness.dark:
        return Colors.white70;
    }

    return null;
  }

  Color _subtitleTextColor(ThemeData theme) {
    if (!enabled) {
      return theme.disabledColor;
    }

    assert(theme.brightness != null);
    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black54;
      case Brightness.dark:
        return Colors.white54;
    }

    return null;
  }

  bool _isDenseLayout() {
    return dense ?? false;
  }

  TextStyle _titleTextStyle(ThemeData theme) {
    TextStyle style = theme.textTheme.subtitle1;
    final Color color = _textColor(theme);
    return _isDenseLayout()
      ? style.copyWith(color: color, fontSize: 13)
      : style.copyWith(color: color);
  }

  TextStyle _subtitleTextStyle(ThemeData theme) {
    TextStyle style = theme.textTheme.bodyText1;
    final Color color = _subtitleTextColor(theme);
    return _isDenseLayout()
      ? style.copyWith(color: color, fontSize: 12)
      : style.copyWith(color: color);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    IconThemeData iconThemeData;
    if (leading != null || trailing != null) {
      iconThemeData = IconThemeData(
        color: _iconColor(theme),
      );
    }

    Widget leadingWidget;
    Widget trailingWidget;

    if (leading is Icon) {
      leadingWidget = IconTheme.merge(
        data: iconThemeData,
        child: _leading(theme),
      );
    } else {
      leadingWidget = _leading(theme);
    }

    if (trailing is Icon) {
      trailingWidget = IconTheme.merge(
        data: iconThemeData,
        child: _trailing(theme),
      );
    } else {
      trailingWidget = _trailing(theme);
    }

    final TextStyle titleStyle = _titleTextStyle(theme);
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
    );

    Widget subtitleText;
    TextStyle subtitleStyle;
    String subtitle = _summary();
    if (subtitle != null) {
      subtitleStyle = _subtitleTextStyle(theme);
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
      );
    }

    return InkWell(
      onTap: enabled ? onTap : null,
      onLongPress: enabled ? onLongPress : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leadingWidget,
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText,
                  if (subtitleText != null) Container(height: 4),
                  if (subtitleText != null) subtitleText,
                  if (bottom != null) bottom,
                ],
              ),
              flex: 1,
            ),
            Container(width: 8),
            trailingWidget,
          ],
        ),
      ),
    );
  }
}

class CheckBoxPreference extends Preference {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String summaryOn;
  final String summaryOff;

  @override
  String _summary() => summary != null ? summary : (value ? summaryOn : summaryOff);

  CheckBoxPreference({
    Key key,
    @required String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    @required this.value,
    @required this.onChanged,
    this.summaryOn,
    this.summaryOff,
  }) :
    assert(summary != null || (summaryOn != null && summaryOff != null)),
    super(
      key: key,
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing ?? Checkbox(value: value, onChanged: enabled ? onChanged : null),
      onTap: () => onChanged(!value),
      enabled: enabled,
    );
}

abstract class DialogPreference<T> extends Preference {
  final String dialogTitle;
  final ValueChanged<T> onChanged;

  DialogPreference({
    Key key,
    @required String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    @required this.dialogTitle,
    @required this.onChanged,
  }) :
    super(
      key: key,
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled
    );

  Widget makeDialog(BuildContext context);

  void _showDialog(BuildContext context) async {
    T result = await showDialog<T>(
      context: context,
      builder: (BuildContext context) {
        return makeDialog(context);
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  /// Copying the build method from Preference is not at all what I want to do,
  /// but I could not find any way to create a dialog from onTap, as I cannot
  /// reference instance members from an initializer. As onTap must be final in Preference,
  /// I cannot think of a way to show the dialog without entirely copying build.
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    IconThemeData iconThemeData;
    if (leading != null || trailing != null) {
      iconThemeData = IconThemeData(
        color: _iconColor(theme),
      );
    }

    Widget leadingWidget;
    Widget trailingWidget;

    if (leading is Icon) {
      leadingWidget = IconTheme.merge(
        data: iconThemeData,
        child: _leading(theme),
      );
    } else {
      leadingWidget = _leading(theme);
    }

    if (trailing is Icon) {
      trailingWidget = IconTheme.merge(
        data: iconThemeData,
        child: _trailing(theme),
      );
    } else {
      trailingWidget = _trailing(theme);
    }

    final TextStyle titleStyle = _titleTextStyle(theme);
    final Widget titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
    );

    Widget subtitleText;
    TextStyle subtitleStyle;
    String subtitle = _summary();
    if (subtitle != null) {
      subtitleStyle = _subtitleTextStyle(theme);
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis),
      );
    }

    return InkWell(
      onTap: !enabled
        ? null
        : () => _showDialog(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leadingWidget,
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleText,
                  if (subtitleText != null) Container(height: 4),
                  if (subtitleText != null) subtitleText,
                  if (bottom != null) bottom,
                ],
              ),
              flex: 1,
            ),
            Container(width: 8),
            trailingWidget,
          ],
        ),
      ),
    );
  }
}

class EditTextPreference extends DialogPreference<String> {
  final String value;
  final bool autofocus;
  final bool obscureText;

  EditTextPreference({
    Key key,
    @required String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    String dialogTitle,
    @required this.value,
    @required ValueChanged<String> onChanged,
    this.autofocus = false,
    this.obscureText = false,
  }) :
    super(
      key: key,
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
      dialogTitle: dialogTitle,
      onChanged: onChanged,
    );

  @override
  Widget makeDialog(BuildContext context) {
    TextEditingController controller = TextEditingController(text: value);

    return AlertDialog(
      title: dialogTitle != null ? Text(dialogTitle) : null,
      contentPadding: const EdgeInsets.all(4),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: controller,
              autofocus: autofocus ?? false,
              keyboardType: TextInputType.text,
              maxLines: 1,
              obscureText: obscureText ?? false,
              enableInteractiveSelection: true,
              onSubmitted: (String value) {
                Navigator.of(context).pop(controller.text);
              },
            ),
          );
        },
      ),
      actions: [
        FlatButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        FlatButton(
          child: const Text("OK"),
          onPressed: () => Navigator.of(context).pop(controller.text),
        ),
      ],
    );
  }
}

class ListPreference<T> extends DialogPreference<T> {
  final T value;
  final List<String> entries;
  final List<T> entryValues;

  ListPreference({
    Key key,
    @required String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    String dialogTitle,
    ValueChanged<T> onChanged,
    @required this.value,
    @required this.entries,
    @required this.entryValues,
  }) :
    assert(entries != null && entries.length > 0),
    assert(entryValues != null && entryValues.length > 0),
    assert(value != null && entryValues.contains(value)),
    assert(entries.length == entryValues.length),
    super(
      key: key,
      title: title,
      summary: summary != null ? summary : entries[entryValues.indexOf(value)],
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
      dialogTitle: dialogTitle,
      onChanged: onChanged,
    );

  @override
  Widget makeDialog(BuildContext context) {
    T currentValue = value;

    return AlertDialog(
      title: dialogTitle != null ? Text(dialogTitle) : null,
      contentPadding: const EdgeInsets.all(4),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  if (entryValues[index] != currentValue) {
                    setState(() {
                      currentValue = entryValues[index];
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Radio<T>(
                        groupValue: currentValue,
                        value: entryValues[index],
                        onChanged: (T newValue) {
                          setState(() {
                            currentValue = newValue;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(entries[index]),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      actions: [
        FlatButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        FlatButton(
          child: const Text("OK"),
          onPressed: () => Navigator.of(context).pop(currentValue),
        ),
      ],
    );
  }
}

class MultiSelectListPreference extends DialogPreference<List<bool>> {
  final List<String> entries;
  final List<bool> entryValues;
  final String Function(List<bool> values) formatSummary;

  MultiSelectListPreference({
    Key key,
    @required String title,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    String dialogTitle,
    ValueChanged<List<bool>> onChanged,
    @required this.entries,
    @required this.entryValues,
    @required this.formatSummary,
  }) :
    assert(entries != null && entries.length > 0),
    assert(entryValues != null && entryValues.length > 0),
    assert(entries.length == entryValues.length),
    super(
      key: key,
      title: title,
      summary: formatSummary != null ? formatSummary(entryValues) : null,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
      dialogTitle: dialogTitle,
      onChanged: onChanged,
    );

  @override
  Widget makeDialog(BuildContext context) {
    List<bool> currentValues = List<bool>.from(entryValues);

    return AlertDialog(
      title: dialogTitle != null ? Text(dialogTitle) : null,
      contentPadding: const EdgeInsets.all(4),
      content: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  setState(() {
                    currentValues[index] = !currentValues[index];
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Checkbox(
                        value: currentValues[index],
                        onChanged: (bool newValue) {
                          setState(() {
                            currentValues[index] = newValue;
                          });
                        },
                      ),
                      Expanded(
                        child: Text(entries[index]),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      actions: [
        FlatButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        FlatButton(
          child: const Text("OK"),
          onPressed: () => Navigator.of(context).pop(currentValues),
        ),
      ],
    );
  }
}

class SeekBarPreference extends Preference {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final bool showValue;
  final int divisions;
  final String Function(double value) formatText;

  SeekBarPreference({
    Key key,
    @required String title,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    @required this.value,
    this.min = 0.0,
    this.max = 100.0,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.showValue = false,
    this.divisions,
    this.formatText,
  }) :
    super(
      key: key,
      title: title,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
      bottom: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              child: Slider.adaptive(
                value: value,
                min: min,
                max: max,
                onChanged: enabled ? onChanged : null,
                onChangeStart: onChangeStart,
                onChangeEnd: onChangeEnd,
                divisions: divisions,
              ),
              padding: const EdgeInsets.only(right: 8),
            ),
            flex: 1,
          ),
//          if (showValue) Text(value.toStringAsPrecision(4)),
          if (showValue) Text(formatText != null ? formatText(value) : value.toStringAsPrecision(4)),
        ],
      ),
    );
}

class SwitchPreference extends CheckBoxPreference {
  SwitchPreference({
    Key key,
    @required String title,
    String summary,
    String summaryOn,
    String summaryOff,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    @required bool value,
    @required ValueChanged<bool> onChanged,
  }) :
    super(
      key: key,
      title: title,
      summary: summary,
      summaryOn: summaryOn,
      summaryOff: summaryOff,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing ?? Switch.adaptive(value: value, onChanged: enabled ? onChanged : null),
      enabled: enabled,
      value: value,
      onChanged: onChanged,
    );
}

class TextPreference extends Preference {
  TextPreference({
    Key key,
    @required String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
    VoidCallback onTap,
    VoidCallback onLongPress,
  }) :
    super(
      key: key,
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
      onTap: onTap,
      onLongPress: onLongPress,
    );
}