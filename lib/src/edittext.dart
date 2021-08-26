import 'package:flutter/material.dart';

import 'dialog.dart';

class EditTextPreference extends DialogPreference<String> {
  final String value;
  final bool? autoFocus;
  final bool? obscureText;

  EditTextPreference({
    required this.value,
    this.autoFocus = false,
    this.obscureText = false,
    required String dialogTitle,
    required ValueChanged<String> onChanged,
    required String title,
    String? summary,
    bool? dense,
    Color? iconColor,
    Widget? leading,
    Widget? trailing,
    bool enabled = true,
  }) :
    super(
      dialogTitle: dialogTitle,
      onChanged: onChanged,
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
    );

  @override
  Widget makeDialog(BuildContext context) {
    final controller = TextEditingController(text: value);
    return AlertDialog(
      title: Text(dialogTitle),
      contentPadding: const EdgeInsets.all(4),
      scrollable: true,
      content: StatefulBuilder(
        builder: (context, StateSetter setState) => Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: controller,
            autofocus: autoFocus ?? false,
            keyboardType: TextInputType.text,
            maxLines: 1,
            obscureText: obscureText ?? false,
            enableInteractiveSelection: true,
            onSubmitted: (value) => Navigator.of(context).pop(controller.text),
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(null),
        ),
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.of(context).pop(controller.text),
        ),
      ],
    );
  }
}
