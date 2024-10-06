import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todo_timer.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/widgets/calendar_dialog.dart';
import 'package:daily_receipt/widgets/receipt_button.dart';
import 'package:daily_receipt/widgets/timer_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  int? editingId;

  @override
  Widget build(BuildContext context) {
    final Todos todosProvider = Provider.of<Todos>(context, listen: true);
    final calendarProvider = Provider.of<Calendar>(context, listen: true);
    List<Todo> todos =
        todosProvider.groupedTodosByDate[calendarProvider.selectedDate] ?? [];

    void addTodo() {
      if (addController.text.isEmpty) return;

      final newTodo = Todo(
        id: todosProvider.todos.length,
        content: addController.text,
        createdAt: DateTime.now().toUtc(),
        scheduledDate: calendarProvider.selectedDate,
      );

      todosProvider.add(newTodo);
      addController.clear();
    }

    void updateTodo() {
      if (editController.text.isEmpty || editingId == null) return;

      todosProvider.update(editingId!, editController.text);
      setState(() {
        editingId = null;
      });
      editController.clear();
    }

    void showTimerBottomSheet(BuildContext context, Todo todo) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
        builder: (context) {
          return ChangeNotifierProvider(
            create: (_) => TodoTimer(),
            child: TimerBottomSheet(
              todo: todo,
              onCompleted: (focusedTime) {
                todosProvider.addAccumulatedTime(todo.id, focusedTime);
                Navigator.of(context).pop();
              },
            ),
          );
        },
      );
    }

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
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                        ),
                        IconButton(
                          onPressed: () => showDialog(
                              context: context,
                              builder: (context) => const CalendarDialog()),
                          icon: const Icon(Icons.calendar_month_rounded),
                          iconSize: 28,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ],
                    ),
                    TableCalendar(
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
                        return todosProvider.groupedTodosByDate[day] != null
                            ? [true]
                            : [];
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
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        weekendStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                      calendarStyle: CalendarStyle(
                        defaultTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        weekendTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        todayTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        selectedTextStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        todayDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          shape: BoxShape.circle,
                        ),
                        markersAnchor: 4,
                        markersAlignment: Alignment.topRight,
                        markerMargin: const EdgeInsets.only(right: 5),
                        markerSize: 8,
                        markerDecoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.tertiary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      rowHeight: 60,
                    ),
                    TextField(
                      controller: addController,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                      cursorColor: Theme.of(context).colorScheme.onSurface,
                      decoration: InputDecoration(
                        hintText: 'Collect moments',
                        hintStyle: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 12),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.add_rounded,
                            size: 32,
                          ),
                          color: Theme.of(context).colorScheme.onSurface,
                          onPressed: addTodo,
                        ),
                      ),
                      onSubmitted: (_) => addTodo(),
                    ),
                    Expanded(
                      child: todos.isNotEmpty
                          ? ListView.builder(
                              itemCount: todos.length,
                              itemBuilder: (context, index) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    checkboxTheme: CheckboxThemeData(
                                      side: MaterialStateBorderSide.resolveWith(
                                        (states) => BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: IconButton(
                                      icon: Icon(
                                        todos[index].isDone
                                            ? Icons.check_circle
                                            : Icons.circle_outlined,
                                        color: todos[index].isDone
                                            ? Theme.of(context)
                                                .colorScheme
                                                .tertiary
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                      ),
                                      onPressed: () {
                                        todosProvider
                                            .toggleDone(todos[index].id);
                                      },
                                    ),
                                    title: editingId == todos[index].id
                                        ? TextField(
                                            controller: editController,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                            cursorColor: Theme.of(context)
                                                .colorScheme
                                                .onSurface,
                                            decoration: InputDecoration(
                                              isDense: true,
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiary,
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.all(0),
                                            ),
                                            onSubmitted: (_) => updateTodo(),
                                          )
                                        : Text(
                                            todos[index].content,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                                ),
                                          ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        editingId == todos[index].id
                                            ? IconButton(
                                                icon: const Icon(Icons.check),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .tertiary,
                                                onPressed: updateTodo,
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.edit),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .onPrimary,
                                                onPressed: () {
                                                  setState(() {
                                                    editingId = todos[index].id;
                                                    editController.text =
                                                        todos[index].content;
                                                  });
                                                },
                                              ),
                                        IconButton(
                                          icon: const Icon(Icons.close),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                          onPressed: () {
                                            todosProvider
                                                .remove(todos[index].id);
                                          },
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.timer),
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          onPressed: () {
                                            showTimerBottomSheet(
                                                context, todos[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                'No todos for this day',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary),
                              ),
                            ),
                    ),
                  ],
                ),
              ),
            ),
            // 수정된 버튼 영역
            ReceiptButton(
              onPressed: () {
                GoRouter.of(context).go('/details', extra: {
                  'selectedDate': calendarProvider.selectedDate,
                });
              },
              text: 'Print the Receipt',
            ),
          ],
        ),
      ),
    );
  }
}
