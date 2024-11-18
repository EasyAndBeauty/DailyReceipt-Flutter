import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationService {
  static final LocalizationService _instance = LocalizationService._internal();
  factory LocalizationService() => _instance;

  LocalizationService._internal();

  late AppLocalizations _translations;
  late Locale _locale;

  // getter for translations
  AppLocalizations get tr => _translations;
  Locale get locale => _locale;

  void updateLocale(BuildContext context) {
    _locale = Localizations.localeOf(context);
    _translations = AppLocalizations.of(context)!;
  }

  // 초기화 여부 체크를 위한 플래그
  bool _initialized = false;
  bool get isInitialized => _initialized;

  void initialize(BuildContext context) {
    if (!_initialized) {
      updateLocale(context);
      _initialized = true;
    }
  }
}

// 간단한 접근을 위한 전역 getter
AppLocalizations get tr => LocalizationService().tr;
