extension DateTimeExtension on DateTime {
  bool get isToday => isSameDay(DateTime.now());

  ///Returns the date with h:m:s equal to 0
  DateTime get justDate => DateTime(year, month, day);

  bool isSameDay(DateTime? date) =>
      date == null ? false : justDate == date.justDate;
}
