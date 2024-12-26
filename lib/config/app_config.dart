import 'environment.dart';
import 'dart:io' show Platform;

class AppConfig {
 final String baseUrl;
 final Environment environment;

 const AppConfig._({
   required this.baseUrl,
   required this.environment,
 });

 static late AppConfig instance;


 static String _getDevBaseUrl() => Platform.isAndroid 
   ? 'http://10.0.2.2:8000' 
   : 'http://127.0.0.1:8000';

 static AppConfig _createConfig(Environment env) => AppConfig._(
   baseUrl: env == Environment.dev 
     ? _getDevBaseUrl()
     : 'https://api.example.com',
   environment: env,
 );

 static void initialize(Environment env) {
   print('✅ Platform.isAndroid: ${Platform.isAndroid}'); // 디버그용 로그 추가
   instance = _createConfig(env);
 }
}