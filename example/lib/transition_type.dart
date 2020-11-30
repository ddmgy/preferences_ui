enum TransitionType {
  Default,
  Fade,
  Rotation,
  Scale,
  Slide,
}

const _names = [
  "Default",
  "Fade",
  "Rotation",
  "Scale",
  "Slide",
];

extension TransitionTypeExtensions on TransitionType {
  int toInt() => index;

  String get name => _names[index];
}

extension IntToTransitionTypeExtensions on int {
  TransitionType toTransitionType() {
    assert(this >= 0 && this < TransitionType.values.length, "value for TransitionType.toInt must be in range [0, ${TransitionType.values.length})");
    return TransitionType.values[this];
  }
}