import 'environment.dart';

class AppConfig {
  final String baseUrl;
  final Environment environment;

  AppConfig({required this.baseUrl, required this.environment});

  static late AppConfig instance;

  static void initialize(Environment env) {
    switch (env) {
      case Environment.dev:
        instance = AppConfig(
          baseUrl: 'http://127.0.0.1:8000', // Development Server
          environment: Environment.dev,
        );
        break;
      case Environment.prd:
        instance = AppConfig(
          baseUrl: 'https://api.example.com', // Production Server
          environment: Environment.prd,
        );
        break;
    }
  }
}
