import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/screens/receipt_detail.dart';
import 'package:daily_receipt/screens/splash.dart';
import 'package:daily_receipt/screens/todos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './theme.dart';
import 'package:go_router/go_router.dart';

void main() {
  final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen(); // const 키워드 추가
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const TodosScreen();
        },
        routes: <RouteBase>[
          GoRoute(
            path: 'details',
            builder: (BuildContext context, GoRouterState state) {
              final Map<String, dynamic> extra =
                  state.extra as Map<String, dynamic>;
              return ReceiptDetailScreen(
                selectedDate: extra['selectedDate'],
              );
            },
          ),
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
