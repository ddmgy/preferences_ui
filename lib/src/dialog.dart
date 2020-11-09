import 'package:flutter/material.dart';

import 'base.dart';

abstract class DialogPreference<T> extends Preference {
  final String dialogTitle;
  final ValueChanged<T> onChanged;

  DialogPreference({
    @required this.dialogTitle,
    @required this.onChanged,
    @required String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
  }) :
    super(
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: trailing,
      enabled: enabled,
    );

  Widget makeDialog(BuildContext context);

  @override
  Widget getOverlayWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !enabled
          ? null
          : () async {
            T result = await showDialog<T>(
              context: context,
              builder: (BuildContext context) => makeDialog(context),
            );

            if (result != null) {
              onChanged(result);
            }
        },
      ),
    );
  }
}
