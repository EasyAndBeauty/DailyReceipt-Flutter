import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  static const String tokenKey = 'auth_token';
  final SharedPreferences _prefs;

  TokenService(this._prefs);

  // 토큰 가져오기
  Future<String?> getToken() async {
    return _prefs.getString(tokenKey);
  }

  // 토큰 저장하기
  Future<void> saveToken(String token) async {
    await _prefs.setString(tokenKey, token);
  }

  // 토큰 삭제하기
  Future<void> removeToken() async {
    await _prefs.remove(tokenKey);
  }
}

