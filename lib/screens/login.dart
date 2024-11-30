import 'package:daily_receipt/services/social_login_service.dart';
import 'package:daily_receipt/widgets/dashed_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:daily_receipt/services/localization_service.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<bool> _visible = List.generate(4, (_) => false);

  @override
  void initState() {
    super.initState();
    _startAnimation();
  }

  void _startAnimation() async {
    for (int i = 0; i < _visible.length; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      if (mounted) {
        setState(() {
          _visible[i] = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                child: Column(
                  children: [
                    const Spacer(flex: 1),
                    AnimatedOpacity(
                      opacity: _visible[0] ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: const TitleSection(),
                    ),
                    const Spacer(flex: 1),
                    AnimatedOpacity(
                      opacity: _visible[1] ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: const Logo(),
                    ),
                    const Spacer(flex: 1),
                    AnimatedOpacity(
                      opacity: _visible[2] ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DashedLine(),
                          SocialButtonsSection(),
                          DashedLine(),
                        ],
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: _visible[3] ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      child: const LocaleLoginButton(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/icons/icon.svg',
      width: 100,
      height: 100,
    );
  }
}

class TitleSection extends StatelessWidget {
  const TitleSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Expanded 제거하고 단순 Column 사용
    return Column(
      mainAxisSize: MainAxisSize.min, // Column이 필요한 만큼만 공간 차지
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          tr.key48,
          style: theme.textTheme.headlineLarge?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        Text(
          tr.key1,
          style: theme.textTheme.titleMedium
              ?.copyWith(color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}

class SocialButtonsSection extends StatelessWidget {
  const SocialButtonsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socialLoginService = SocialLoginService();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SocialLoginButton(
          onPressed: () async {
            try {
              final userCredential =
                  await socialLoginService.signInWithGoogle();
              if (userCredential != null && context.mounted) {
                GoRouter.of(context).go('/');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Google 로그인 실패: $e')),
                );
              }
            }
          },
          text: tr.key49('Google'),
        ),
        const SizedBox(height: 4),
        SocialLoginButton(
          onPressed: () async {
            try {
              final userCredential = await socialLoginService.signInWithApple();
              if (userCredential != null && context.mounted) {
                GoRouter.of(context).go('/');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Apple 로그인 실패: $e')),
                );
              }
            }
          },
          text: tr.key49('Apple'),
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
          text: tr.key49('Local'),
        ),
        const SizedBox(height: 16),
        Text(
          tr.key50,
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
          foregroundColor: theme.colorScheme.onSurface,
          backgroundColor: Colors.transparent,
          disabledForegroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          padding: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          enabledMouseCursor: SystemMouseCursors.click,
          disabledMouseCursor: SystemMouseCursors.basic,
          overlayColor: Colors.transparent,
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
              Icons.chevron_right, // 오른쪽 화살표 아이콘
              color: theme.colorScheme.onSurface,
            ),
          ],
        ),
      ),
    );
  }
}
