import 'package:flutter/material.dart';

import 'base.dart';

class TwoStatePreference extends Preference {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String? summaryOn;
  final String? summaryOff;

  TwoStatePreference({
    required this.value,
    required this.onChanged,
    this.summaryOn,
    this.summaryOff,
    required String title,
    String? summary,
    bool? dense,
    Color? iconColor,
    Widget? leading,
    Widget? trailing,
    bool enabled = true,
  }) :
    assert(summary != null || (summaryOn != null && summaryOff != null)),
    super(
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      enabled: enabled,
      trailing: trailing,
      onTap: () => onChanged(!value),
    );

  @override
  String getSummary() => summary != null ? summary! : (value ? summaryOn! : summaryOff!);
}
