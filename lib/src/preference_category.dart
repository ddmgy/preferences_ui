import 'package:flutter/material.dart';

import 'preference.dart';

class PreferenceCategory extends StatelessWidget {
  final String title;
  final List<Preference> preferences;

  const PreferenceCategory({
    Key key,
    this.title,
    this.preferences,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title == null
          ? Container()
          : Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: preferences.length,
          itemBuilder: (BuildContext context, int index) {
            return Material(
              color: Theme.of(context).cardColor,
              child: preferences[index],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Divider(
              height: 1,
              indent: 8,
              endIndent: 8,
              color: Theme.of(context).brightness == Brightness.light
                ? null
                : Colors.transparent,
            );
          },
        ),
      ],
    );
  }
}
