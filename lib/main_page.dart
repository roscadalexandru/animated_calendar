import 'style.dart';
import 'package:flutter/material.dart';

import 'calendar/calendar.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Material(
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: kToolbarHeight,
                alignment: Alignment.center,
                child: Text(
                  'Calendar',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              CalendarWidget(
                initialDate: DateTime.now(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
