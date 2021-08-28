import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthHeader extends StatelessWidget {
  const MonthHeader({Key? key, required this.dates}) : super(key: key);

  final List<DateTime> dates;

  @override
  Widget build(BuildContext context) {
    final monthsAsString =
        dates.map((date) => DateFormat('MMMM').format(date)).toSet();

    return Text(
      monthsAsString.join('-'),
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    );
  }
}
