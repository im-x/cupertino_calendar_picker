// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:cupertino_calendar_picker/src/src.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalendarWeekdays extends StatelessWidget {
  const CalendarWeekdays({required this.decoration, super.key});

  final CalendarWeekdayDecoration decoration;

  List<Widget> _weekdays(BuildContext context) {
    assert(debugCheckHasCupertinoLocalizations(context));
    assert(debugCheckHasMaterialLocalizations(context));

    final DateTime nowDate = DateTime.now();
    final int year = nowDate.year;
    final int month = nowDate.month;
    final int firstDayOffset = DateUtils.firstDayOffset(
      year,
      month,
      MaterialLocalizations.of(context),
    );
    final CupertinoLocalizations localization =
        CupertinoLocalizations.of(context);
    final DateTime firstDayOfWeekDate = DateTime(year, month).subtract(
      Duration(days: firstDayOffset),
    );
    return List<Widget>.generate(DateTime.daysPerWeek, (int index) {
      final DateTime date = firstDayOfWeekDate.addDays(index);
      String weekDay = '';
      if (date.weekday == DateTime.sunday) {
        weekDay = '周日';
      } else if (date.weekday == DateTime.monday) {
        weekDay = '周一';
      } else if (date.weekday == DateTime.tuesday) {
        weekDay = '周二';
      } else if (date.weekday == DateTime.wednesday) {
        weekDay = '周三';
      } else if (date.weekday == DateTime.thursday) {
        weekDay = '周四';
      } else if (date.weekday == DateTime.friday) {
        weekDay = '周五';
      } else if (date.weekday == DateTime.saturday) {
        weekDay = '周六';
      }

      return Expanded(
        child: CalendarWeekday(
          weekday: weekDay,
          decoration: decoration,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: calendarWeekdaysHeight,
      margin: const EdgeInsets.symmetric(
        horizontal: calendarWeekdaysHorizontalPadding,
      ),
      child: Row(
        children: _weekdays(context),
      ),
    );
  }
}
