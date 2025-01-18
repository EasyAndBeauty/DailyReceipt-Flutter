import 'environment.dart';
import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
 final String baseUrl;
 final Environment environment;

 const AppConfig._({
   required this.baseUrl,
   required this.environment,
 });

 static late AppConfig instance;


 static String _getDevBaseUrl() { 
  
  final url = Platform.isAndroid 
   ? dotenv.env['DEV_ANDROID_BASE_URL']
   : dotenv.env['DEV_IOS_BASE_URL'];

   if (url == null) {
     throw Exception('Missing required environment variable: DEV_BASE_URL_${Platform.isAndroid ? 'ANDROID' : 'IOS'}');
   }
   
   return url;
 }

 static AppConfig _createConfig(Environment env){ 
  
  final baseUrl = env == Environment.dev 
     ? _getDevBaseUrl()
     : dotenv.env['PRD_BASE_URL'];

  if (baseUrl == null) {
    throw Exception('Missing required environment variable: PRD_BASE_URL');
  }

  return AppConfig._(
   baseUrl: baseUrl,
   environment: env,
  );
 }

 static void initialize(Environment env) {
   print('✅ Platform.isAndroid: ${Platform.isAndroid}');
   print('✅ dotenv.env: ${dotenv.env}');
   instance = _createConfig(env);
 }
}