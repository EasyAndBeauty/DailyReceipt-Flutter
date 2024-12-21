import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todo_timer.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/services/localization_service.dart';
import 'package:daily_receipt/widgets/calendar_dialog.dart';
import 'package:daily_receipt/widgets/receipt_button.dart';
import 'package:daily_receipt/widgets/timer_bottom_sheet.dart';
import 'package:daily_receipt/widgets/todo_action_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uuid/uuid.dart';

class TodosScreen extends StatefulWidget {
  const TodosScreen({super.key});

  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final TextEditingController addController = TextEditingController();
  final TextEditingController editController = TextEditingController();
  String? editingId;
  final Uuid _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final Todos todosProvider = Provider.of<Todos>(context, listen: true);
    final calendarProvider = Provider.of<Calendar>(context, listen: true);

    List<Todo> todos =
        todosProvider.groupedTodosByDate[calendarProvider.selectedDate] ?? [];

    void updateTodo() {
      if (editController.text.isEmpty || editingId == null) return;

      todosProvider.update(editingId!, editController.text);

      setState(() {
        editingId = null;
      });
      editController.clear();
    }

    void addTodo() {
      if (addController.text.isEmpty) return;

      final newTodo = Todo(
        id: _uuid.v4(),
        content: addController.text,
        createdAt: DateTime.now().toUtc(),
        scheduledDate: calendarProvider.selectedDate,
      );

      todosProvider.add(newTodo);
      addController.clear();
    }

    void showTodoActionBottomSheet(BuildContext context, Todo todo) {
      showCupertinoModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => TodoActionBottomSheet(
          todo: todo,
          onEdit: () {
            setState(() {
              editingId = todo.id; // 수정할 Todo의 ID 저장
              editController.text = todo.content; // 수정할 내용을 텍스트 필드에 표시
            });
          },
        ),
      );
    }

    void showTimerBottomSheet(BuildContext context, Todo todo) {
      showCupertinoModalBottomSheet(
        context: context,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
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
                    ),
                    TextField(
                      controller: addController,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      cursorColor: theme.colorScheme.onSurface,
                      decoration: InputDecoration(
                        hintText: tr.key2,
                        hintStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.secondary,
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: theme.colorScheme.tertiary,
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
                          color: theme.colorScheme.onSurface,
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
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: IconButton(
                                    icon: Icon(
                                      todos[index].isDone
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      color: todos[index].isDone
                                          ? theme.colorScheme.tertiary
                                          : theme.colorScheme.onSurface,
                                    ),
                                    onPressed: () {
                                      todosProvider.toggleDone(todos[index].id);
                                    },
                                  ),
                                  title: editingId == todos[index].id
                                      ? TextField(
                                          controller: editController,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                          cursorColor:
                                              theme.colorScheme.onSurface,
                                          decoration: InputDecoration(
                                            isDense: true,
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    theme.colorScheme.tertiary,
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color:
                                                    theme.colorScheme.tertiary,
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                          onSubmitted: (_) => updateTodo(),
                                        )
                                      : Text(
                                          todos[index].content,
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                  onTap: () {
                                    showTimerBottomSheet(context, todos[index]);
                                  },
                                  trailing: IconButton(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: theme.colorScheme.onPrimary,
                                    ),
                                    onPressed: () {
                                      showTodoActionBottomSheet(
                                          context, todos[index]);
                                    },
                                  ),
                                );
                              })
                          : Center(
                              child: Text(
                                tr.key3,
                                style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.secondary),
                              ),
                            ),
                    ),
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
