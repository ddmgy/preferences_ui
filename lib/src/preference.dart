import 'package:flutter/material.dart';

abstract class Preference extends StatelessWidget {
  final String title;
  final String summary;
  final bool enabled;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  Preference({
    Key key,
    @required this.title,
    this.summary,
    this.icon,
    this.iconColor,
    this.onTap,
    this.onLongPress,
    this.enabled = true,
  }) : super(key: key);
}

class CheckBoxPreference extends Preference {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String summaryOn;
  final String summaryOff;

  CheckBoxPreference({
    Key key,
    @required String title,
    String summary,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled = true,
    @required this.value,
    @required this.onChanged,
    this.summaryOn,
    this.summaryOff,
  }) :
    super(
      key: key,
      title: title,
      summary: summary != null ? summary : (value ? summaryOn : summaryOff),
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
    );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (enabled != null && enabled)
        ? () {
            onChanged(!value);
          }
        : null,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              child: icon != null
                ? Icon(
                  icon,
                  color: iconColor,
                )
                : null,
              width: 24,
              height: 24,
              alignment: Alignment.center,
            ),
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                  Container(
                    height: summary != null ? 4 : 0,
                  ),
                  summary != null
                    ? Text(
                        summary,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: Theme.of(context).textTheme.subtitle2.fontSize - 2,
                          color: Theme.of(context).textTheme.subtitle2.color.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                      )
                    : Container(),
                ],
              ),
              flex: 1,
            ),
            Checkbox(
              value: value,
              onChanged: enabled ? onChanged : null,
            ),
          ],
        ),
      ),
    );
  }
}

class EditTextPreference extends Preference {
  final String value;
  final ValueChanged<String> onChanged;
  final String dialogTitle;
  final bool autofocus;
  final bool obscureText;

  EditTextPreference({
    Key key,
    @required String title,
    String summary,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled = true,
    @required this.value,
    @required this.onChanged,
    @required this.dialogTitle,
    this.autofocus,
    this.obscureText,
  }) :
    super(
      key: key,
      title: title,
      summary: summary,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
    );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (enabled != null && enabled)
        ? () async {
            String newValue = await showDialog<String>(
              context: context,
              builder: (BuildContext context) {
                TextEditingController textEditingController = TextEditingController(text: value);
                return AlertDialog(
                  title: dialogTitle != null
                    ? Text(dialogTitle)
                    : null,
                  contentPadding: const EdgeInsets.all(4),
                  content: StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Padding(
                        padding: const EdgeInsets.all(8),
                        child: TextField(
                          controller: textEditingController,
                          autofocus: autofocus != null ? autofocus : false,
                          keyboardType: TextInputType.text,
                          maxLines: 1,
                          obscureText: obscureText != null ? obscureText : false,
                          enableInteractiveSelection: true,
                          onSubmitted: (String value) {
                            Navigator.of(context).pop(textEditingController.text);
                          },
                        ),
                      );
                    },
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                    FlatButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(textEditingController.text);
                      },
                    ),
                  ],
                );
              },
            );
            if (newValue != null) {
              onChanged(newValue);
            }
          }
        : null,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              child: icon != null
                  ? Icon(
                icon,
                color: iconColor,
              )
                  : null,
              width: 24,
              height: 24,
              alignment: Alignment.center,
            ),
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                  Container(
                    height: 4,
                  ),
                  Text(
                    value != null ? value : "",
                    style: Theme.of(context).textTheme.subtitle2.copyWith(
                      fontSize: Theme.of(context).textTheme.subtitle2.fontSize - 2,
                      color: Theme.of(context).textTheme.subtitle2.color.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.start,
                    maxLines: 3,
                  ),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class ListPreference<T> extends Preference {
  final T value;
  final ValueChanged<T> onChanged;
  final List<String> entries;
  final List<T> entryValues;

  ListPreference({
    Key key,
    @required String title,
    String summary,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled = true,
    @required this.value,
    @required this.onChanged,
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
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
    );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (enabled != null && enabled)
        ? () async {
            if (enabled != null && !enabled) {
              return;
            }
            T newValue = await showDialog<T>(
              context: context,
              builder: (BuildContext context) {
                T currentValue = value;
                return AlertDialog(
                  title: title != null
                    ? Text(title)
                    : null,
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
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                children: <Widget>[
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
                  actions: <Widget>[
                    FlatButton(
                      child: const Text("Cancel"),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                    FlatButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(currentValue);
                      },
                    ),
                  ],
                );
              },
            );
            if (newValue != null) {
              onChanged(newValue);
            }
          }
        : null,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              child: icon != null
                  ? Icon(
                      icon,
                      color: iconColor,
                    )
                  : null,
              width: 24,
              height: 24,
              alignment: Alignment.center,
            ),
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                  Container(
                    height: summary != null ? 4 : 0,
                  ),
                  summary != null
                    ? Text(
                        summary,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: Theme.of(context).textTheme.subtitle2.fontSize - 2,
                          color: Theme.of(context).textTheme.subtitle2.color.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                      )
                    : Container(),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class MultiSelectListPreference extends Preference {
  final ValueChanged<List<bool>> onChanged;
  final List<String> entries;
  final List<bool> entryValues;

  MultiSelectListPreference({
    Key key,
    @required String title,
    String summary,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled = true,
    @required this.onChanged,
    @required this.entries,
    @required this.entryValues,
  }) :
    assert(entries != null && entries.length > 0),
    assert(entryValues != null && entryValues.length > 0),
    assert(entries.length == entryValues.length),
    super(
      key: key,
      title: title,
      summary: summary,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
    );

  @override
  Widget build(BuildContext context) {
    String summary = _getSummary();
    return InkWell(
      onTap: (enabled != null && enabled)
        ? () async {
          if (enabled != null && !enabled) {
            return;
          }
          List<bool> newValue = await showDialog<List<bool>>(
          context: context,
          builder: (BuildContext context) {
            List<bool> currentValues = List<bool>.from(entryValues);
            return AlertDialog(
              title: title != null
                ? Text(title)
                : null,
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
                          children: <Widget>[
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
            actions: <Widget>[
              FlatButton(
                child: const Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop(null);
                  },
                ),
              FlatButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(currentValues);
                },
              ),
            ],
          );
        },
      );

      if (newValue != null) {
        onChanged(newValue);
      }
    }
      : null,
      child: Container(
        padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Container(
                child: icon != null
                  ? Icon(
                     icon,
                     color: iconColor,
                    )
                  : null,
                width: 24,
                height: 24,
                alignment: Alignment.center,
              ),
              Container(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: Theme.of(context).textTheme.subtitle1,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                    ),
                    Container(
                      height: summary != null ? 4 : 0,
                    ),
                    summary != null
                      ? Text(
                          summary,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontSize: Theme.of(context).textTheme.subtitle2.fontSize - 2,
                            color: Theme.of(context).textTheme.subtitle2.color.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                        )
                      : Container(),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  String _getSummary() {
    StringBuffer sb = StringBuffer();
    bool alreadyAppended = false;
    for (int i = 0; i < entries.length; i++) {
      if (entryValues[i]) {
        if (alreadyAppended) {
          sb.write(", ");
        } else {
          alreadyAppended = true;
        }
        sb.write(entries[i]);
      }
    }
    return sb.toString();
  }
}

class SeekBarPreference extends Preference {
  final double value;
  final double minValue;
  final double maxValue;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final bool showValue;
  final int divisions;

  SeekBarPreference({
    Key key,
    @required String title,
    String summary,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled = true,
    @required this.value,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.minValue = 0.0,
    this.maxValue = 100.0,
    this.showValue = false,
    this.divisions,
  }) :
    super(
      key: key,
      title: title,
      summary: summary,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
    );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              child: icon != null
                  ? Icon(
                    icon,
                    color: iconColor,
                  )
                  : null,
              width: 24,
              height: 24,
              alignment: Alignment.center,
            ),
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                  Container(
                    height: 4,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Slider.adaptive(
                            divisions: divisions,
                            value: value,
                            onChanged: enabled ? onChanged : null,
                            onChangeStart: onChangeStart,
                            onChangeEnd: onChangeEnd,
                            min: minValue,
                            max: maxValue,
                          ),
                          padding: EdgeInsets.only(right: 8),
                        ),
                        flex: 1,
                      ),
                      showValue
                        ? Text(
                            value.toStringAsPrecision(4),
                          )
                        : Container(),
                    ],
                  ),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class SwitchPreference extends Preference {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String summaryOn;
  final String summaryOff;

  SwitchPreference({
    Key key,
    @required String title,
    String summary,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled = true,
    @required this.value,
    @required this.onChanged,
    this.summaryOn,
    this.summaryOff,
  }) :
    super(
      key: key,
      title: title,
      summary: summary != null ? summary : (value ? summaryOn : summaryOff),
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
    );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (enabled != null && enabled)
        ? () {
            onChanged(!value);
          }
        : null,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              child: icon != null
                  ? Icon(
                icon,
                color: iconColor,
              )
                  : null,
              width: 24,
              height: 24,
              alignment: Alignment.center,
            ),
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                  Container(
                    height: summary != null ? 4 : 0,
                  ),
                  summary != null
                      ? Text(
                          summary,
                          style: Theme.of(context).textTheme.subtitle2.copyWith(
                            fontSize: Theme.of(context).textTheme.subtitle2.fontSize - 2,
                            color: Theme.of(context).textTheme.subtitle2.color.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                        )
                      : Container(),
                ],
              ),
              flex: 1,
            ),
            Switch(
              value: value,
              onChanged: enabled ? onChanged : null,
            ),
          ],
        ),
      ),
    );
  }
}

class TextPreference extends Preference {
  TextPreference({
    Key key,
    @required String title,
    String summary,
    IconData icon,
    Color iconColor,
    VoidCallback onTap,
    VoidCallback onLongPress,
    bool enabled = true,
  }) :
    super(
      key: key,
      title: title,
      summary: summary,
      icon: icon,
      iconColor: iconColor,
      onTap: onTap,
      onLongPress: onLongPress,
      enabled: enabled,
    );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (enabled != null && enabled && onTap != null)
        ? onTap
        : null,
      child: Container(
        padding: EdgeInsets.all(8),
        child: Row(
          children: <Widget>[
            Container(
              child: icon != null
                ? Icon(
                  icon,
                  color: iconColor,
                )
                : null,
              width: 24,
              height: 24,
              alignment: Alignment.center,
            ),
            Container(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1,
                    textAlign: TextAlign.start,
                    maxLines: 1,
                  ),
                  Container(
                    height: summary != null ? 4 : 0,
                  ),
                  summary != null
                    ? Text(
                        summary,
                        style: Theme.of(context).textTheme.subtitle2.copyWith(
                          fontSize: Theme.of(context).textTheme.subtitle2.fontSize - 2,
                          color: Theme.of(context).textTheme.subtitle2.color.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.start,
                        maxLines: 3,
                      )
                    : Container(),
                ],
              ),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }
}
