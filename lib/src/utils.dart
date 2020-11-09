import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  Color iconColor() {
    final theme = Theme.of(this);

    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black87;
      default:
        return null;
    }
  }

  Color textColor() {
    final theme = Theme.of(this);

    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black87;
      case Brightness.dark:
        return Colors.white70;
      default:
        return null;
    }
  }

  Color subtitleTextColor() {
    final theme = Theme.of(this);

    switch (theme.brightness) {
      case Brightness.light:
        return Colors.black54;
      case Brightness.dark:
        return Colors.white54;
      default:
        return null;
    }
  }

  TextStyle titleTextStyle({double fontSize: 16}) {
    final style = Theme.of(this).textTheme.subtitle1;
    final color = textColor();
    return style.copyWith(
      color: color,
      fontSize: fontSize,
    );
  }

  TextStyle subtitleTextStyle({double fontSize: 12}) {
    final style = Theme.of(this).textTheme.bodyText1;
    final color = subtitleTextColor();
    return style.copyWith(
      color: color,
      fontSize: fontSize,
    );
  }
}
