import 'package:cupertino_calendar/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// /// Displays the days of a given month and allows choosing a day.
// ///
// /// The days are arranged in a rectangular grid with one column for each day of
// /// the week.
class CalendarMonthPicker extends StatefulWidget {
  /// Creates a day picker.
  CalendarMonthPicker({
    required this.monthPageController,
    required this.onMonthPageChanged,
    required this.currentDate,
    required this.displayedMonth,
    required this.minimumDate,
    required this.maximumDate,
    required this.selectedDate,
    required this.onChanged,
    required this.dayDecoration,
    required this.todayDecoration,
    super.key,
  })  : assert(!minimumDate.isAfter(maximumDate)),
        assert(!selectedDate.isBefore(minimumDate)),
        assert(!selectedDate.isAfter(maximumDate));

  final PageController monthPageController;
  final ValueChanged<int> onMonthPageChanged;

  /// The currently selected date.
  ///
  /// This date is highlighted in the picker.
  final DateTime selectedDate;

  /// The current date at the time the picker is displayed.
  final DateTime currentDate;

  /// Called when the user picks a day.
  final ValueChanged<DateTime> onChanged;

  /// The earliest date the user is permitted to pick.
  ///
  /// This date must be on or before the [maximumDate].
  final DateTime minimumDate;

  /// The latest date the user is permitted to pick.
  ///
  /// This date must be on or after the [minimumDate].
  final DateTime maximumDate;

  /// The month whose days are displayed by this picker.
  final DateTime displayedMonth;

  final CalendarDayDecoration dayDecoration;
  final CalendarDayDecoration todayDecoration;

  @override
  State<CalendarMonthPicker> createState() => CalendarMonthPickerState();
}

class CalendarMonthPickerState extends State<CalendarMonthPicker> {
  Iterable<Widget> _days(BuildContext context, int index) sync* {
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final DateTime monthDate =
        DateUtils.addMonthsToMonthDate(widget.minimumDate, index);
    final int year = monthDate.year;
    final int month = monthDate.month;
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);

    int day = -dayOffset;
    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        yield const SizedBox();
      } else {
        late CalendarDayStyle style;

        final DateTime nowDate = DateTime.now();
        final DateTime date = DateTime(year, month, day);
        final bool isToday = DateUtils.isSameDay(nowDate, date);

        if (DateUtils.isSameDay(widget.selectedDate, date)) {
          style = CalendarDayStyle.selected;
        } else if (isToday) {
          style = CalendarDayStyle.today;
        } else {
          style = CalendarDayStyle.defaultDay;
        }

        final CalendarDay dayWidget = CalendarDay(
          day: '$day',
          decoration: widget.dayDecoration,
          todayDecoration: widget.todayDecoration,
          style: style,
        );
        yield dayWidget;
      }
    }
  }

  int _rowCount(int daysLength) {
    /// If a month has such a week structure or similar, then [daysLength] will be [36]
    /// and therefore [_rowCount] will be [6]
    /// Su Mo Tu We Th Fr St
    /// __ __ __ __ __ __ 01
    /// 02 03 04 05 06 07 08
    /// 09 10 11 12 13 14 15
    /// 16 17 18 19 20 21 22
    /// 23 24 25 26 27 28 29
    /// 30
    if (daysLength > 35) {
      return 6;

      /// If a month has such a week structure, then [daysLength] will be [28]
      /// and therefore [_rowCount] will be [4]
      /// Su Mo Tu We Th Fr St
      /// 01 02 03 04 05 06 07
      /// 08 09 10 11 12 13 14
      /// 15 16 17 18 19 20 21
      /// 22 23 24 25 26 27 28
    } else if (daysLength < 29) {
      return 4;
    } else {
      /// In other cases [rowCount] will be [5]
      return 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));

    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    const TextStyle dayStyle = TextStyle(fontSize: 20.0, letterSpacing: 0.38);
    final Color enabledDayColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.label,
        darkColor: CupertinoColors.label.darkColor,
      ),
      context,
    );
    final Color disabledDayColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.opaqueSeparator,
        darkColor: CupertinoColors.opaqueSeparator.darkColor,
      ),
      context,
    );
    final Color selectedDayColor = CupertinoDynamicColor.resolve(
      CupertinoDynamicColor.withBrightness(
        color: CupertinoColors.systemRed,
        darkColor: CupertinoColors.systemRed.darkColor,
      ),
      context,
    );
    final Color selectedDayBackground = selectedDayColor.withOpacity(0.12);
    final Color todayColor = selectedDayColor;

    final int year = widget.displayedMonth.year;
    final int month = widget.displayedMonth.month;

    final List<Widget> dayItems = <Widget>[];
    final int daysInMonth = DateUtils.getDaysInMonth(year, month);
    final int dayOffset = DateUtils.firstDayOffset(year, month, localizations);
    // 1-based day of month, e.g. 1-31 for January, and 1-29 for February on
    // a leap year.
    int day = -dayOffset;

    while (day < daysInMonth) {
      day++;
      if (day < 1) {
        dayItems.add(const SizedBox());
      } else {
        final DateTime dayToBuild = DateTime(year, month, day);
        final bool isDisabled = dayToBuild.isAfter(widget.maximumDate) ||
            dayToBuild.isBefore(widget.minimumDate);
        final bool isSelectedDay = DateUtils.isSameDay(
          widget.selectedDate,
          dayToBuild,
        );
        final bool isToday =
            DateUtils.isSameDay(widget.currentDate, dayToBuild);

        BoxDecoration? decoration;
        Color dayColor = enabledDayColor;
        Color? backgroundColor;
        FontWeight dayFontWeight = FontWeight.w400;

        if (isSelectedDay) {
          dayFontWeight = FontWeight.w600;
          dayColor = selectedDayColor;
          backgroundColor = selectedDayBackground;
          decoration = BoxDecoration(
            color: selectedDayBackground,
            shape: BoxShape.circle,
          );
        }

        if (isToday) {
          if (isSelectedDay) {
            backgroundColor = selectedDayColor;
            dayColor = CupertinoColors.white;
          } else {
            dayColor = todayColor;
          }
          decoration = BoxDecoration(
            color: backgroundColor,
            shape: BoxShape.circle,
          );
        }

        if (isDisabled) {
          dayColor = disabledDayColor;
        }

        Widget dayWidget = DecoratedBox(
          decoration: decoration ?? const BoxDecoration(),
          child: Center(
            child: Text(
              '$day',
              style: dayStyle
                  .copyWith(fontWeight: dayFontWeight)
                  .apply(color: dayColor),
            ),
          ),
        );

        if (!isDisabled) {
          dayWidget = GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => widget.onChanged(dayToBuild),
            child: dayWidget,
          );
        }

        dayItems.add(dayWidget);
      }
    }

    /// [+ 1] to include the last month
    final int itemCount = DateUtils.monthDelta(
          widget.minimumDate,
          widget.maximumDate,
        ) +
        1;

    return Expanded(
      child: PageView.builder(
        controller: widget.monthPageController,
        itemBuilder: (BuildContext context, int index) {
          final Iterable<Widget> days = _days(context, index);
          return GridView.custom(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: CalendarMonthGridDelegate(
              rowCount: _rowCount(days.length),
              calendarDayRowHeight: calendarDayRowHeight,
            ),
            childrenDelegate: SliverChildListDelegate(
              days.toList(),
              addRepaintBoundaries: false,
            ),
          );
        },
        itemCount: itemCount,
        onPageChanged: widget.onMonthPageChanged,
      ),
    );
  }
}
