import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/services/localization_service.dart';
import 'package:daily_receipt/widgets/add_todo_input_field.dart';
import 'package:daily_receipt/widgets/calendar_dialog.dart';
import 'package:daily_receipt/widgets/receipt_button.dart';
import 'package:daily_receipt/widgets/todo_list.dart';
import 'package:daily_receipt/widgets/weekly_date_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final calendarProvider = Provider.of<Calendar>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('MMMM')
                              .format(calendarProvider.selectedDate)
                              .toString(),
                          style: theme.textTheme.headlineLarge?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const CalendarDialog()),
                          icon: const Icon(Icons.calendar_month_rounded),
                          iconSize: 28,
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                    const WeeklyDateSelector(),
                    AddTodoInputField(),
                    const TodoList(),
                  ],
                ),
              ),
            ),
            ReceiptButton(
              onPressed: () {
                GoRouter.of(context).go('/details', extra: {
                  tr.key4: calendarProvider.selectedDate,
                });
              },
              text: tr.key5,
            ),
          ],
        ),
      ),
    );
  }
}
