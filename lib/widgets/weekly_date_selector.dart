import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class WeeklyDateSelector extends StatelessWidget {
  const WeeklyDateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final calendarProvider = Provider.of<Calendar>(context, listen: true);
    final Todos todosProvider = Provider.of<Todos>(context, listen: true);

    return TableCalendar(
      firstDay: DateTime.utc(2023, 1, 1),
      lastDay: DateTime.utc(2034, 12, 31),
      focusedDay: calendarProvider.selectedDate.toLocal(),
      calendarFormat: CalendarFormat.week,
      onDaySelected: (selectedDay, focusedDay) {
        calendarProvider.selectDate(selectedDay);
      },
      selectedDayPredicate: (day) {
        return isSameDay(calendarProvider.selectedDate, day);
      },
      eventLoader: (day) {
        return todosProvider.groupedTodosByDate[day] != null ? [true] : [];
      },
      headerStyle: const HeaderStyle(
        titleTextStyle: TextStyle(fontSize: 0),
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerMargin: EdgeInsets.zero,
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
        ),
        weekendStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
        ),
      ),
      calendarStyle: CalendarStyle(
        defaultTextStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
        ),
        weekendTextStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
        ),
        todayTextStyle: TextStyle(
          color: theme.colorScheme.onPrimary,
        ),
        selectedTextStyle: TextStyle(
          color: theme.colorScheme.primary,
        ),
        todayDecoration: BoxDecoration(
          color: theme.colorScheme.secondary,
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: theme.colorScheme.onPrimary,
          shape: BoxShape.circle,
        ),
        markersAnchor: 4,
        markersAlignment: Alignment.topRight,
        markerMargin: const EdgeInsets.only(right: 5),
        markerSize: 8,
        markerDecoration: BoxDecoration(
          color: theme.colorScheme.tertiary,
          shape: BoxShape.circle,
        ),
      ),
      rowHeight: 60,
    );
  }
}
