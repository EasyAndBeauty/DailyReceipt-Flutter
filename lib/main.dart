import 'package:daily_receipt/screens/todos.dart';
import 'package:flutter/material.dart';

import './theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Receipt',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      home: const SafeArea(child: TodosScreen()),
    );
  }
}
