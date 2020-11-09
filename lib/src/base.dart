import 'package:flutter/material.dart';

import 'utils.dart';

abstract class BasePreference {
  bool enabled;

  BasePreference({
    this.enabled = true,
  });

  Widget toWidget(BuildContext context);
}

class Preference extends BasePreference {
  final String title;
  final String summary;
  final bool dense;
  final Color iconColor;
  final Widget leading;
  final Widget trailing;
  final Widget bottom;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  Preference({
    this.title,
    this.summary,
    this.dense,
    this.iconColor,
    this.leading,
    this.trailing,
    this.bottom,
    this.onTap,
    this.onLongPress,
    bool enabled = true,
  }) : super(enabled: enabled);

  Widget getLeadingWidget(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      child: leading,
    );
  }

  Widget getTrailingWidget(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: trailing,
    );
  }

  String getSummary() => summary;

  Color getIconColor(BuildContext context) {
    if (!enabled) {
      return Theme.of(context).disabledColor;
    }

    if (iconColor != null) {
      return iconColor;
    }

    return context.iconColor();
  }

  Color getTextColor(BuildContext context) {
    if (!enabled) {
      return Theme.of(context).disabledColor;
    }

    return context.textColor();
  }

  Color getSubtitleTextColor(BuildContext context) {
    if (!enabled) {
      return Theme.of(context).disabledColor;
    }

    return context.subtitleTextColor();
  }

  bool getIsDenseLayout() => dense ?? false;

  TextStyle getTitleTextStyle(BuildContext context) {
    final style = context.titleTextStyle();
    final color = getTextColor(context);
    return getIsDenseLayout()
      ? style.copyWith(color: color, fontSize: 13)
      : style.copyWith(color: color);
  }

  TextStyle getSubtitleTextStyle(BuildContext context) {
    final style = context.subtitleTextStyle();
    final color = getSubtitleTextColor(context);
    return getIsDenseLayout()
      ? style.copyWith(color: color, fontSize: 12)
      : style.copyWith(color: color);
  }

  Widget getOverlayWidget(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: enabled ? onTap : null,
        onLongPress: enabled ? onLongPress : null,
      ),
    );
  }

  @override
  Widget toWidget(BuildContext context) {
    final theme = Theme.of(context);

    IconThemeData iconThemeData;
    if (leading != null || trailing != null) {
      iconThemeData = IconThemeData(
        color: getIconColor(context),
      );
    }

    Widget leadingWidget = getLeadingWidget(context);
    Widget trailingWidget = getTrailingWidget(context);

    if (leading is Icon) {
      leadingWidget = IconTheme.merge(
        data: iconThemeData,
        child: leadingWidget,
      );
    }

    if (trailing is Icon) {
      trailingWidget = IconTheme.merge(
        data: iconThemeData,
        child: trailingWidget,
      );
    }

    final titleStyle = getTitleTextStyle(context);
    final titleText = AnimatedDefaultTextStyle(
      style: titleStyle,
      duration: kThemeChangeDuration,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );

    Widget subtitleText;
    TextStyle subtitleStyle;
    final subtitle = getSummary();
    if (subtitle != null) {
      subtitleStyle = getSubtitleTextStyle(context);
      subtitleText = AnimatedDefaultTextStyle(
        style: subtitleStyle,
        duration: kThemeChangeDuration,
        child: Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    final overlay = getOverlayWidget(context);

    return Stack(
      children: [
        Material(
          color: theme.cardColor,
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: leadingWidget,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      titleText,
                      if (subtitleText != null) Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: subtitleText,
                      ),
                      if (bottom != null) bottom,
                    ],
                  ),
                  flex: 1,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: trailingWidget,
                ),
              ],
            ),
          ),
        ),
        if (overlay != null) Positioned.fill(
          child: overlay,
        ),
      ],
    );
  }
}

abstract class PreferenceWithChildren extends BasePreference {
  final List<BasePreference> children;

  PreferenceWithChildren({
    this.children = const [],
    bool enabled = true,
  }) : super(enabled: enabled) {
    if (!(enabled ?? false)) {
      children.forEach((child) => child.enabled = enabled);
    }
  }
}

class PreferenceDivider extends BasePreference {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;

  PreferenceDivider({
    this.height = 1,
    this.thickness = 1,
    this.indent = 8,
    this.endIndent = 8,
    bool enabled = true,
  }) : super(enabled: enabled);

  @override
  Widget toWidget(BuildContext context) {
    Color dividerColor = Theme.of(context)?.brightness == Brightness.light
      ? null
      : Colors.transparent;

    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: dividerColor,
    );
  }
}

class PreferenceGroup extends PreferenceWithChildren {
  final String title;

  PreferenceGroup({
    this.title,
    List<BasePreference> children,
    bool enabled = true,
  }) :
    super(
      children: children,
      enabled: enabled,
    );

  @override
  Widget toWidget(BuildContext context) {
    final theme = Theme.of(context);
    Widget titleWidget = title == null
      ? Container()
      : Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            title,
            style: TextStyle(
              color: theme.accentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
    final body = ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: children.length,
      itemBuilder: (context, index) {
        return Material(
          color: theme.cardColor,
          child: children[index].toWidget(context),
        );
      },
      separatorBuilder: (context, index) {
        return PreferenceDivider().toWidget(context);
      },
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget,
        body,
      ],
    );
  }
}
