import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/screens/receipt_detail.dart';
import 'package:daily_receipt/screens/todos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme.dart';
import 'package:go_router/go_router.dart';

void main() {
  var goRoute = GoRoute(
    path: 'details',
    builder: (BuildContext context, GoRouterState state) {
      return ReceiptDetailScreen();
    },
  );
  final GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const TodosScreen();
        },
        routes: <RouteBase>[
          goRoute,
        ],
      ),
    ],
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Todos()),
      ChangeNotifierProvider(create: (context) => Calendar()),
    ],
    child: MyApp(router: router),
  ));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Daily Receipt',
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
