import 'package:daily_receipt/widgets/dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:daily_receipt/services/social_login_service.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:daily_receipt/services/localization_service.dart';
import 'package:daily_receipt/widgets/dashed_line_painter.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  // final SocialLoginService _socialLoginService = SocialLoginService();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
          child: Column(
            children: [
              Spacer(flex: 1),
              LogoSection(),
              Spacer(flex: 1),
              DashedLine(),
              SocialButtonsSection(),
              DashedLine(),
              LocaleLoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class LogoSection extends StatelessWidget {
  const LogoSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      // Column을 Expanded로 감싸기
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // 세로 중앙 정렬
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'GET STARTED',
            style: theme.textTheme.headlineLarge?.copyWith(
              color: theme.colorScheme.secondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(tr.key1,
              style: theme.textTheme.titleMedium
                  ?.copyWith(color: theme.colorScheme.onSurface)),
          const SizedBox(height: 4),
          SvgPicture.asset(
            'assets/icons/icon.svg',
            width: 100,
            height: 100,
          ),
        ],
      ),
    );
  }
}

class SocialButtonsSection extends StatelessWidget {
  const SocialButtonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialLoginButton(
          onPressed: () {
            print('Google 로그인 성공');
            GoRouter.of(context).go('/');
          },
          text: 'Continue with Google',
        ),
        const SizedBox(height: 4),
        SocialLoginButton(
          onPressed: () {
            print('Apple 로그인 성공');
            GoRouter.of(context).go('/');
          },
          text: 'Continue with Apple',
        ),
      ],
    );
  }
}

class LocaleLoginButton extends StatelessWidget {
  const LocaleLoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialLoginButton(
          onPressed: () {
            print('loacl 로그인 성공');
            GoRouter.of(context).go('/');
          },
          text: 'Continue with Local',
        ),
        const SizedBox(height: 16),
        Text(
          'if you don’t have an account,\nusing only local features',
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.secondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final String? icon; // 아이콘은 선택적으로 변경

  const SocialLoginButton({
    Key? key,
    required this.onPressed,
    required this.text,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          side: BorderSide.none,
          padding: EdgeInsets.zero,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // 텍스트와 화살표를 양끝으로
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  SvgPicture.asset(
                    icon!,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 12),
                ],
                Text(
                  text,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward, // 오른쪽 화살표 아이콘
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
