import 'package:flutter/material.dart';

import 'dialog.dart';

typedef SummaryFormatter = String Function(List<bool> values);

class MultiSelectListPreference extends DialogPreference<List<bool>> {
  final List<String> entries;
  final List<bool> entryValues;
  final SummaryFormatter formatSummary;

  MultiSelectListPreference({
    @required this.entries,
    @required this.entryValues,
    @required this.formatSummary,
    @required String dialogTitle,
    @required ValueChanged<List<bool>> onChanged,
    @required String title,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
  }) :
    assert(entries != null && entries.isNotEmpty),
    assert(entryValues != null && entryValues.isNotEmpty),
    assert(entries.length == entryValues.length),
    super(
      dialogTitle: dialogTitle,
      onChanged: onChanged,
      title: title,
      summary: formatSummary != null ? formatSummary(entryValues) : null,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
    );

  @override
  Widget makeDialog(BuildContext context) {
    List<bool> currentValues = List<bool>.from(entryValues);
    return AlertDialog(
      title: dialogTitle != null ? Text(dialogTitle) : null,
      contentPadding: const EdgeInsets.all(4),
      scrollable: true,
      content: StatefulBuilder(
        builder: (context, StateSetter setState) {
          final children = List<Widget>.generate(entries.length, (index) {
            return InkWell(
              onTap: () {
                setState(() {
                  currentValues[index] = !currentValues[index];
                });
              },
              child: Container(
                height: kMinInteractiveDimension,
                padding: const EdgeInsets.symmetric(horizontal: 16),
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
          onPressed: () => Navigator.of(context).pop(currentValues),
        ),
      ],
    );
  }
}
