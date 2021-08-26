import 'package:flutter/material.dart';

import 'twostate.dart';

class CheckBoxPreference extends TwoStatePreference {
  CheckBoxPreference({
    required bool value,
    required ValueChanged<bool> onChanged,
    String? summaryOff,
    String? summaryOn,
    required String title,
    String? summary,
    bool? dense,
    Color? iconColor,
    Widget? leading,
    bool enabled = true,
  }) : super(
    value: value,
    onChanged: onChanged,
    summaryOff: summaryOff,
    summaryOn: summaryOn,
    title: title,
    dense: dense,
    iconColor: iconColor,
    leading: leading,
    trailing: Checkbox(value: value, onChanged: !enabled ? null : (bool? newValue) {
      if (newValue != null) {
        onChanged(newValue);
      }
    }),
    enabled: enabled,
  );
}
