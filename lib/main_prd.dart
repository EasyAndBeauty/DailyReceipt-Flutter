import 'package:flutter/material.dart';
import 'config/app_config.dart';
import 'config/environment.dart';
import 'config/di.dart';
import 'main.dart';

const String flavor = String.fromEnvironment('FLAVOR', defaultValue: 'prd');

void main() {
  // 운영 환경 초기화
  print('✅ FLAVOR PRD: $flavor');
  AppConfig.initialize(Environment.prd);
  setupDI();

  runApp(MyApp(router: createRouter()));

}
