import 'package:flutter/widgets.dart';

class TransitionsSettings {
  final Curve curve;
  final Duration duration;

  const TransitionsSettings({
    this.curve,
    this.duration,
  }) :
    assert(curve != null),
    assert(duration != null);

  TransitionsSettings copyWith({Curve curve, Duration duration}) => TransitionsSettings(
    curve: curve ?? this.curve,
    duration: duration ?? this.duration,
  );
}

const _defaultTransitionsSettings = TransitionsSettings(
  curve: Curves.fastOutSlowIn,
  duration: Duration(milliseconds: 300),
);

TransitionsSettings _transitionsSettings;

TransitionsSettings get transitionsSettings =>
  _transitionsSettings ?? _defaultTransitionsSettings;

set transitionsSettings(TransitionsSettings settings) =>
  _transitionsSettings = settings;

RouteTransitionsBuilder _preferencePageTransitionsBuilder;

RouteTransitionsBuilder get preferencePageTransitionsBuilder =>
  _preferencePageTransitionsBuilder ?? defaultTransitionsBuilder;

set preferencePageTransitionsBuilder(RouteTransitionsBuilder transitionsBuilder) =>
  _preferencePageTransitionsBuilder = transitionsBuilder;

Widget defaultTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child) {
  return child;
}

Widget fadeTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child) {
  final _opacityAnimation = CurvedAnimation(
    parent: animation,
    curve: transitionsSettings.curve,
  );
  return FadeTransition(opacity: _opacityAnimation, child: child);
}

Widget rotationTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child) {
  final _turnsAnimation = CurvedAnimation(
    parent: animation,
    curve: transitionsSettings.curve,
  );
  return RotationTransition(turns: _turnsAnimation, child: child);
}

Widget scaleTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child) {
  final _scaleAnimation = CurvedAnimation(
    parent: animation,
    curve: transitionsSettings.curve,
  );
  return ScaleTransition(scale: _scaleAnimation, child: child);
}

Widget slideTransitionsBuilder(
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child) {
  final _positionAnimation = Tween<Offset>(
    begin: const Offset(-1.0, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: animation,
    curve: transitionsSettings.curve,
  ));
  return SlideTransition(position: _positionAnimation, child: child);
}