import 'package:daily_receipt/models/calendar.dart';
import 'package:daily_receipt/models/todos.dart';
import 'package:daily_receipt/screens/receipt_detail.dart';
import 'package:daily_receipt/screens/splash.dart';
import 'package:daily_receipt/screens/todos.dart';
import 'package:daily_receipt/services/localization_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './theme.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;

  final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
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

      // 다국어 지원
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      // 시스템 언어 사용 (null = 시스템 설정 따름)
      locale: null,

      // LocalizationService 초기화
      builder: (context, child) {
        LocalizationService().initialize(context);
        return child!;
      },
    );
  }
}
