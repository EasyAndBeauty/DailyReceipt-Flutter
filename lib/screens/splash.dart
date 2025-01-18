import 'package:daily_receipt/config/di.dart';
import 'package:daily_receipt/services/token_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:daily_receipt/services/localization_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  void _checkAuthStatus() async {
    final tokenService = getIt.get<TokenService>();
    final token = await tokenService.getToken(forceRefresh: true);
    if (!mounted) return;
    if (token != null) {
      // 토큰이 있으면 메인 화면으로
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      GoRouter.of(context).go('/');
    } else {
      // 토큰이 없으면 로그인 화면으로
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return;
      GoRouter.of(context).go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/icon.svg',
              width: 100,
              height: 100,
            ),
            const SizedBox(height: 4),
            Text(tr.key1,
                style: theme.textTheme.titleLarge
                    ?.copyWith(color: theme.colorScheme.onSurface)),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
