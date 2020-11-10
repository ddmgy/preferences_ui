import 'package:flutter/material.dart';

import 'base.dart';

typedef TextFormatter = String Function(double value);

class SeekBarPreference extends Preference {
  final double value;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChangeEnd;
  final bool showValue;
  final int divisions;
  final TextFormatter formatText;

  SeekBarPreference({
    @required this.value,
    this.min = 0,
    this.max = 100,
    @required this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.showValue = false,
    this.divisions,
    this.formatText,
    @required String title,
    bool dense,
    Color iconColor,
    Widget leading,
    Widget trailing,
    bool enabled = true,
  }) : super(
    title: title,
    dense: dense,
    iconColor: iconColor,
    leading: leading,
    trailing: trailing,
    enabled: enabled,
  );

  @override
  Widget getBottomWidget(BuildContext context) => Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              height: 60,
              child: Slider(
                value: value,
                min: min,
                max: max,
                onChanged: enabled ? onChanged : null,
                onChangeStart: onChangeStart,
                onChangeEnd: onChangeEnd,
                divisions: divisions,
              ),
            ),
          ),
          flex: 1,
        ),
        if (showValue) Text(
          formatText != null ? formatText(value) : value.toStringAsPrecision(4),
        ),
      ],
    );

  @override
  Widget getOverlayWidget(BuildContext context) => null;
}
