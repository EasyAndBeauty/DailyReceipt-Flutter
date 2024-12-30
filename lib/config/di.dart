import 'package:daily_receipt/services/social_login_service.dart';
import 'package:daily_receipt/services/token_service.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import 'app_config.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDI() async {
  print('✅ DI 설정 시작');
  print('✅ AppConfig Base URL: ${AppConfig.instance.baseUrl}');
  print('✅ Environment: ${AppConfig.instance.environment}');

  final sharedPrefs = await SharedPreferences.getInstance();

  // TokenService
  getIt.registerSingleton<TokenService>(TokenService(sharedPrefs));

  // AuthService
  getIt.registerSingleton<AuthService>(
    AuthService(baseUrl: AppConfig.instance.baseUrl),
  );

  // SocialLoginService
  getIt.registerSingleton<SocialLoginService>(
    SocialLoginService(
      authService: getIt.get<AuthService>(),
      tokenService: getIt.get<TokenService>(),
    ),
  );

  print('✅ DI 설정 완료');
}
