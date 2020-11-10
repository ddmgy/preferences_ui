enum DaysOfTheWeek {
  Sunday,
  Monday,
  Tuesday,
  Wednesday,
  Thursday,
  Friday,
  Saturday,
}

const _names = [
  "Sunday",
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
];

extension DayOfTheWeekExtensions on DaysOfTheWeek {
  int toInt() => index;

  String get name => _names[index];
}

extension IntToDaysOfTheWeekExtensions on int {
  DaysOfTheWeek toDaysOfTheWeek() {
    assert(this >= 0 && this < DaysOfTheWeek.values.length, "value for DaysOfTheWeek.toInt must be in range [0, ${DaysOfTheWeek.values.length})");
    return DaysOfTheWeek.values[this];
  }
}
