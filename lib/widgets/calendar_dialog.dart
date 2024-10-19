import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatelessWidget {
  const CalendarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<Calendar>(context, listen: false);
    final todosProvider = Provider.of<Todos>(context, listen: false);
    final theme = Theme.of(context);

    return Dialog(
      backgroundColor: theme.colorScheme.onSurface,
      surfaceTintColor: theme.colorScheme.onSurface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 420,
          child: TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2034, 12, 31),
            focusedDay: calendarProvider.selectedDate.toLocal(),
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {
              calendarProvider.selectDate(selectedDay);
              Navigator.pop(context);
            },
            selectedDayPredicate: (day) {
              return isSameDay(calendarProvider.selectedDate, day);
            },
            eventLoader: (day) {
              return todosProvider.groupedTodosByDate[day] != null
                  ? [true]
                  : [];
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextFormatter: (date, locale) {
                return DateFormat('yyyy.MM.').format(date).toString();
              },
              titleTextStyle: theme.textTheme.titleLarge!.copyWith(
                color: theme.colorScheme.primary,
              ),
              headerPadding: const EdgeInsets.only(top: 6, bottom: 6),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: theme.colorScheme.secondary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: theme.colorScheme.secondary,
              ),
            ),
            calendarStyle: CalendarStyle(
              tablePadding: const EdgeInsets.all(8),
              todayTextStyle: TextStyle(
                color: theme.colorScheme.onPrimary,
              ),
              todayDecoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: theme.colorScheme.onPrimary,
              ),
              selectedDecoration: BoxDecoration(
                color: theme.colorScheme.primary,
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
              defaultTextStyle: TextStyle(
                color: theme.colorScheme.primary,
              ),
            ),
            daysOfWeekHeight: 30,
          ),
        ),
      ),
    );
  }
}
