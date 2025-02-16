import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/widgets/calendar_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final calendarProvider = Provider.of<Calendar>(context, listen: true);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          DateFormat('MMMM').format(calendarProvider.selectedDate).toString(),
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        IconButton(
          onPressed: () => showDialog(
              context: context, builder: (context) => const CalendarDialog()),
          icon: const Icon(Icons.calendar_month_rounded),
          iconSize: 28,
          color: theme.colorScheme.secondary,
        ),
      ],
    );
  }
}
