import 'package:daily_receipt/services/auth_service.dart'; // 주석 처리
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'config/app_config.dart';
import 'config/environment.dart';
import 'config/di.dart';
import 'models/calendar.dart';
import 'models/todos.dart';
import 'screens/splash.dart';
import 'screens/login.dart';
import 'screens/todos.dart';
import 'screens/receipt_detail.dart';
import 'services/localization_service.dart';
import 'theme.dart';
import 'firebase_options.dart';

// FLAVOR 환경 변수 설정
const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🔑 Firebase 초기화 (환경에 따라 옵션 분리)
  await Firebase.initializeApp(
    options: flavor == 'prd'
        ? DefaultFirebaseOptions.currentPlatform // Production
        : DefaultFirebaseOptions.currentPlatform, // Development
  );

  print('✅ FLAVOR: $flavor');

  // 🔑 AppConfig 초기화
  AppConfig.initialize(
    flavor == 'prd' ? Environment.prd : Environment.dev,
  );

  print('✅ AppConfig: ${AppConfig.instance.environment}');

  // 🔑 DI 설정
  await setupDI();

  GoogleFonts.config.allowRuntimeFetching = false;

  // 🔑 GoRouter 설정
  final GoRouter router = createRouter();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Todos()),
      ChangeNotifierProvider(create: (context) => Calendar()),
    ],
    child: MyApp(router: router),
  ));
}

/// GoRouter 설정
GoRouter createRouter() {
  return GoRouter(
    initialLocation: '/splash',
    routes: <RouteBase>[
      GoRoute(
        path: '/splash',
        builder: (BuildContext context, GoRouterState state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginScreen();
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
                selectedDate: extra[tr.key4],
              );
            },
          ),
        ],
      ),
    ],
  );
}

/// 메인 앱 위젯
class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({Key? key, required this.router}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConfig.instance.environment == Environment.prd
          ? 'Daily Receipt (Production)'
          : 'Daily Receipt (Development)',
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
