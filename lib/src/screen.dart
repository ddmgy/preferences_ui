import 'package:flutter/material.dart';

import 'base.dart';

class PreferenceScreen extends StatelessWidget {
  final String title;
  final List<BasePreference> children;
  final List<Widget> actions;

  PreferenceScreen({
    Key key,
    @required this.title,
    this.children = const [],
    this.actions = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final body = ListView.builder(
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (context, index) => Container(
        padding: EdgeInsets.only(
          top: index == 0 ? 0 : 4,
          bottom: index == children.length - 1 ? 0 : 4,
        ),
        child: children[index].toWidget(context),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: actions,
      ),
      body: Scrollbar(
        child: body,
      ),
    );
  }
}
