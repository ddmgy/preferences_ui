import 'package:flutter/material.dart';

import 'base.dart';
import 'screen.dart';
import 'transition.dart';

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
        onTap: () => Navigator.of(context).push(PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => PreferenceScreen(
            title: title,
            children: children,
            actions: actions,
          ),
          transitionsBuilder: preferencePageTransitionsBuilder,
          transitionDuration: transitionsSettings.duration,
          reverseTransitionDuration: transitionsSettings.duration,
        )),
      ),
    );
  }
}
