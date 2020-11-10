enum ThemeType {
  Light,
  Dark,
}

const _names = [
  "Light",
  "Dark",
];

extension ThemeTypeExtensions on ThemeType {
  int toInt() => index;

  String get name => _names[index];
}

extension IntToThemeTypeExtensions on int {
  ThemeType toThemeType() {
    assert(this >= 0 && this < ThemeType.values.length, "value for ThemeType.toInt must be in range [0, ${ThemeType.values.length})");
    return ThemeType.values[this];
  }
}
