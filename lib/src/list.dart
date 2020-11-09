import 'package:flutter/material.dart';

import 'dialog.dart';

class ListPreference<T> extends DialogPreference<T> {
  final T value;
  final List<String> entries;
  final List<T> entryValues;

  ListPreference({
    @required this.value,
    @required this.entries,
    @required this.entryValues,
    @required String dialogTitle,
    @required ValueChanged<T> onChanged,
    @required String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
  }) :
    assert(entries != null && entries.isNotEmpty),
    assert(entryValues != null && entryValues.isNotEmpty),
    assert(value != null && entryValues.contains(value)),
    assert(entries.length == entryValues.length),
    super(
      dialogTitle: dialogTitle,
      onChanged: onChanged,
      title: title,
      summary: summary != null ? summary : entries[entryValues.indexOf(value)],
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
    );

  @override
  Widget makeDialog(BuildContext context) {
    T currentValue = value;
    return AlertDialog(
      title: dialogTitle != null ? Text(dialogTitle) : null,
      contentPadding: const EdgeInsets.all(4),
      scrollable: true,
      content: StatefulBuilder(
        builder: (context, StateSetter setState) {
          final children = List<Widget>.generate(entries.length, (index) {
            return InkWell(
              onTap: () {
                if (entryValues[index] != currentValue) {
                  setState(() {
                    currentValue = entryValues[index];
                  });
                }
              },
              child: Container(
                height: kMinInteractiveDimension,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
          });
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
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
