import 'package:flutter/material.dart';

import 'base.dart';
import 'screen.dart';

class PreferencePage extends Preference {
  final List<BasePreference> children;
  final List<Widget> actions;

  PreferencePage({
    this.children = const [],
    this.actions = const [],
    String title,
    String summary,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget bottom,
    bool enabled = true,
  }) :
    assert(children != null),
    super(
      title: title,
      summary: summary,
      dense: dense,
      iconColor: iconColor,
      leading: leading,
      trailing: Icon(Icons.chevron_right),
      bottom: bottom,
      enabled: enabled,
    );

  @override
  Widget getOverlayWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (BuildContext context) {
              return PreferenceScreen(
                title: title,
                children: children,
                actions: actions,
              );
            },
          ));
        },
      ),
    );
  }
}
