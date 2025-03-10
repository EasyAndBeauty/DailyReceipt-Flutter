import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/services/localization_service.dart';
import 'package:daily_receipt/widgets/add_todo_input_field.dart';
import 'package:daily_receipt/widgets/header.dart';
import 'package:daily_receipt/widgets/receipt_button.dart';
import 'package:daily_receipt/widgets/todo_list.dart';
import 'package:daily_receipt/widgets/weekly_date_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TodosScreen extends StatelessWidget {
  const TodosScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const Header(),
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
