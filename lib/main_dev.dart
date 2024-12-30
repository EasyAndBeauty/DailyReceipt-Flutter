import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/environment.dart';
import 'config/di.dart';
import 'main.dart';

const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');

void main() {
  // 개발 환경 초기화
  print('✅ FLAVOR DEV: $flavor');
  AppConfig.initialize(Environment.dev);
  setupDI();

  runApp(MyApp(router: createRouter()));
}
