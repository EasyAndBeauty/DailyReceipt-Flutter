import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenService {
  final FirebaseAuth _auth;
  final SharedPreferences _prefs;
  static const String _tokenKey = 'firebase_token';

  TokenService(this._prefs, {FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  Future<String?> getToken({bool forceRefresh = false}) async {
    try {
      // 1. 강제 리프레시 요청인 경우
      if (forceRefresh) {
        return await _getFirebaseToken(forceRefresh: true);
      }

      // 2. 저장된 토큰 확인
      final savedToken = _prefs.getString(_tokenKey);
      if (savedToken != null) {
        return savedToken;
      }

      // 3. 저장된 토큰이 없는 경우만 Firebase API 호출
      return await _getFirebaseToken();
    } catch (e) {
      print('Token error: $e');
      return null;
    }
  }

  Future<String?> _getFirebaseToken({bool forceRefresh = false}) async {
    final user = _auth.currentUser;
    if (user == null) {
      await removeToken();
      return null;
    }

    try {
      // firebase 내부적으로 refresh 토큰 발급
      final token = await user.getIdToken(forceRefresh);
      if (token != null) {
        await _prefs.setString(_tokenKey, token);
      }
      return token;
    } catch (e) {
      print('Firebase token error: $e');
      return null;
    }
  }

  Future<void> removeToken() => _prefs.remove(_tokenKey);
}
