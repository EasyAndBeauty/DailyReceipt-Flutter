// lib/services/social_login_service.dart

import 'dart:math';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:daily_receipt/services/auth_service.dart';
import 'package:daily_receipt/services/token_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SocialLoginService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final AuthService _authService;
  final TokenService _tokenService;

  SocialLoginService(
      {required AuthService authService, required TokenService tokenService})
      : _authService = authService,
        _tokenService = tokenService;

  // Google 로그인
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Google 로그인 진행
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      // 인증 정보 가져오기
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Firebase credential 생성
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase로 로그인
      await _auth.signInWithCredential(credential);

      // 토큰 발급 + 저장
      final token = await _tokenService.getToken(forceRefresh: true);

      if (token == null) {
        throw Exception('Token is not found');
      }

      final userInfo = await _authService.fetchUserInfo(token);

      return userInfo;
    } catch (e) {
      print('Google Sign In Error: $e');
      rethrow;
    }
  }

  // Apple 로그인
  Future<Map<String, dynamic>?> signInWithApple() async {
    try {
      // nonce 생성
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      print('Nonce: $nonce');

      // Apple 로그인 요청
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      print('User Identifier: ${appleCredential.userIdentifier}');
      print('Email: ${appleCredential.email}');

      // Firebase credential 생성
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken!,
        rawNonce: rawNonce,
        accessToken: appleCredential.authorizationCode,
      );

      print('OAuth Credential: ${oauthCredential.accessToken}');

      // Firebase로 로그인
      await _auth.signInWithCredential(oauthCredential);

      // 토큰 발급 + 저장
      final token = await _tokenService.getToken(forceRefresh: true);
      if (token == null) {
        throw Exception('Token is not found');
      }

      final userInfo = await _authService.fetchUserInfo(token);

      return userInfo;
    } catch (e) {
      print('Apple Sign In Error: $e');
      rethrow;
    }
  }

  // nonce 생성 헬퍼 메서드
  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  // SHA256 해시 생성 헬퍼 메서드
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // 로그아웃
  Future<void> signOut() async {
    await _tokenService.removeToken();
    await _auth.signOut();
    await _googleSignIn.signOut();
  }
}
