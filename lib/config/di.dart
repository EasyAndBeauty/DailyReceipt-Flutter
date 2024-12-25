import 'package:get_it/get_it.dart';
import '../services/auth_service.dart';
import 'app_config.dart';

final GetIt getIt = GetIt.instance;

void setupDI() {
  print('✅ DI 설정 시작');
  print('✅ AppConfig Base URL: ${AppConfig.instance.baseUrl}');
  print('✅ Environment: ${AppConfig.instance.environment}');

  getIt.registerSingleton<AuthService>(
    AuthService(baseUrl: AppConfig.instance.baseUrl),
  );

  print('✅ DI 설정 완료');
}
