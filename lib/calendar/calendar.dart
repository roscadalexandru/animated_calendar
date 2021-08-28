import 'package:flutter/material.dart';

import 'date_time_extension.dart';
import 'day_cell.dart';
import 'month_header.dart';

enum WeekState { previous, next, none }

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({
    Key? key,
    required this.initialDate,
    this.onPreviousWeek,
    this.onNextWeek,
    this.onSelect,
    this.monthAlignment = Alignment.center,
    this.showArrows = true,
    this.canSwipe = true,
  }) : super(key: key);

  final DateTime initialDate;
  final ValueChanged<List<DateTime>>? onPreviousWeek;
  final ValueChanged<List<DateTime>>? onNextWeek;
  final ValueChanged<DateTime>? onSelect;
  final Alignment monthAlignment;
  final bool showArrows;
  final bool canSwipe;

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget>
    with TickerProviderStateMixin {
  DateTime? _selectedDate;
  late DateTime _initialDate;
  late DateTime _monday;

  late AnimationController _animationController;

  late List<DateTime> _days;

  WeekState weekState = WeekState.none;

  @override
  void initState() {
    super.initState();

    _initialDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
    );
    _monday = _initialDate.subtract(Duration(days: _initialDate.weekday - 1));

    updateDays();

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {});
      }
    });
  }

  @override
  void didChangeDependencies() {
    _animationController.forward();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onSelect?.call(date);
  }

  void updateDays() {
    _days = List<DateTime>.generate(7, (i) => _monday.add(Duration(days: i)));
  }

  weekUpdate() {
    _animationController.reset();
    updateDays();
    _animationController.forward();
  }

  void updateToPreviousWeek() {
    _monday = _monday.subtract(const Duration(days: 7));
    weekState = WeekState.previous;
    weekUpdate();
    widget.onPreviousWeek?.call(_days);
  }

  void updateToNextWeek() {
    _monday = _monday.add(const Duration(days: 7));
    weekUpdate();
    weekState = WeekState.next;
    widget.onNextWeek?.call(_days);
  }

  void swipeCalendar(DragEndDetails details) {
    int velocitySensitivity = 300;

    if (details.primaryVelocity! < -velocitySensitivity) {
      updateToNextWeek();
    } else if (details.primaryVelocity! > velocitySensitivity) {
      updateToPreviousWeek();
    }
  }

  List<Widget> getDays() {
    double interval = 1 / _days.length;

    return List.from(_days.map((date) {
      double intervalBegin;
      double intervalEnd;

      switch (weekState) {
        case WeekState.previous:
          intervalBegin = 1 - date.weekday * interval;
          intervalEnd = 1 - (date.weekday - 1) * interval;
          break;
        case WeekState.next:
          intervalBegin = (date.weekday - 1) * interval;
          intervalEnd = date.weekday * interval;
          break;
        default:
          intervalBegin = 0;
          intervalEnd = 1;
      }

      final Animation<double> scale =
          Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController,
        curve: Interval(intervalBegin, intervalEnd),
      ));
      return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return ScaleTransition(
            scale: scale,
            child: child,
          );
        },
        child: DayCell(
          date: date,
          isSelected: date.isSameDay(_selectedDate),
          onTap: selectDate,
        ),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: widget.canSwipe ? swipeCalendar : null,
      child: Container(
        color: Colors.transparent,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Visibility(
                  visible: widget.showArrows,
                  child: IconButton(
                    onPressed: updateToPreviousWeek,
                    icon: Icon(Icons.chevron_left),
                  ),
                ),
                Expanded(
                  child: Align(
                      alignment: widget.monthAlignment,
                      child: MonthHeader(dates: _days)),
                ),
                Visibility(
                  visible: widget.showArrows,
                  child: IconButton(
                    onPressed: updateToNextWeek,
                    icon: Icon(Icons.chevron_right),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getDays(),
            ),
          ],
        ),
      ),
    );
  }
}
