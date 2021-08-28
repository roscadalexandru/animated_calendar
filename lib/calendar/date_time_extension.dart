extension DateTimeExtension on DateTime {
  bool get isToday => isSameDay(DateTime.now());
  bool isSameDay(DateTime? date) => date == null
      ? false
      : year == date.year && month == date.month && day == date.day;
}
