import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatelessWidget {
  const CalendarDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TableCalendar(
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2034, 12, 31),
          focusedDay: DateTime.now(),
          calendarFormat: CalendarFormat.month,
        ),
      ),
    );
  }
}
