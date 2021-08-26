import 'package:flutter/material.dart';

import 'base.dart';

class DropDownPreference<T> extends Preference {
  final T value;
  final ValueChanged<T> onChanged;
  final List<String> entries;
  final List<T> entryValues;
  late Rect _lastPress;

  DropDownPreference({
    required this.value,
    required this.onChanged,
    required this.entries,
    required this.entryValues,
    required String title,
    String? summary,
    bool? dense,
    Color? iconColor,
    Widget? leading,
    Widget? trailing,
    bool enabled = true,
  }) :
    assert(entries.isNotEmpty),
    assert(entryValues.isNotEmpty),
    assert(value != null && entryValues.contains(value)),
    assert(entries.length == entryValues.length),
    super(
      title: title,
      summary: summary != null ? summary : entries[entryValues.indexOf(value)],
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
    );

  @override
  Widget getOverlayWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTapDown: (details) {
          _lastPress = Rect.fromLTWH(
            details.globalPosition.dx,
            details.globalPosition.dy,
            0,
            0,
          );
        },
        onTap: !enabled
          ? null
          : () async {
            T? newValue = await showMenu<T>(
              context: context,
              position: RelativeRect.fromSize(
                _lastPress,
                Size(0, 0),
              ),
              items: List.generate(entries.length, (i) {
                return PopupMenuItem(
                  value: entryValues[i],
                  child: Text(
                    entries[i],
                  ),
                );
              }),
            );
            if (newValue != null && newValue != value) {
              onChanged(newValue);
            }
        },
      ),
    );
  }
}
