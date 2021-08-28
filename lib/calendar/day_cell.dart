import '../style.dart';
import 'package:flutter/material.dart';
import 'date_time_extension.dart';

class DayCell extends StatelessWidget {
  const DayCell(
      {Key? key, required this.date, this.onTap, this.isSelected = false})
      : super(key: key);

  final DateTime date;
  final bool isSelected;
  final ValueChanged<DateTime>? onTap;

  static const weekDays = <int, String>{
    1: 'MON',
    2: 'TUE',
    3: 'WED',
    4: 'THU',
    5: 'FRI',
    6: 'SAT',
    7: 'SUN'
  };

  @override
  Widget build(BuildContext context) {
    final isToday = date.isToday;

    return GestureDetector(
      onTap: () => onTap?.call(date),
      child: FittedBox(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  weekDays[date.weekday]!,
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Style.black : Style.grey,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 14.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Style.green
                      : isToday
                          ? Style.lightGreen
                          : null,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: isSelected ? Style.white : Style.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
