import 'package:daily_receipt/models/calendar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatelessWidget {
  const CalendarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final calendarProvider = Provider.of<Calendar>(context, listen: false);

    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SizedBox(
          height: 420,
          child: TableCalendar(
            firstDay: DateTime.utc(2023, 1, 1),
            lastDay: DateTime.utc(2034, 12, 31),
            focusedDay: calendarProvider.selectedDate,
            calendarFormat: CalendarFormat.month,
            onDaySelected: (selectedDay, focusedDay) {
              calendarProvider.selectDate(selectedDay);
              Navigator.pop(context);
            },
            selectedDayPredicate: (day) {
              return isSameDay(calendarProvider.selectedDate, day.toLocal());
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextFormatter: (date, locale) {
                return DateFormat('yyyy.MM.').format(date.toLocal()).toString();
              },
              titleTextStyle: Theme.of(context).textTheme.titleLarge!,
              headerPadding: const EdgeInsets.only(top: 6, bottom: 6),
              leftChevronIcon: Icon(
                Icons.chevron_left,
                color: Theme.of(context).colorScheme.secondary,
              ),
              rightChevronIcon: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            calendarStyle: CalendarStyle(
              tablePadding: const EdgeInsets.all(8),
              todayTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              selectedTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
            daysOfWeekHeight: 30,
          ),
        ),
      ),
    );
  }
}
