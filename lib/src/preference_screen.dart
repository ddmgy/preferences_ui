import 'package:flutter/material.dart';

import 'preference_category.dart';

class PreferenceScreen extends StatelessWidget {
  final List<PreferenceCategory> categories;

  const PreferenceScreen({
    Key key,
    this.categories,
  }) :
    assert(categories != null),
    super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: EdgeInsets.only(
              top: index == 0 ? 0 : 4,
              bottom: index == categories.length - 1 ? 0 : 4,
            ),
            child: categories[index],
          );
        },
      ),
    );
  }
}
