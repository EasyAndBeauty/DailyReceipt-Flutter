import 'package:daily_receipt/services/dio_service.dart';

class AuthService {
  final DioService _dioService;

  AuthService({
    required DioService dioService,
  }) : _dioService = dioService;

  Future<Map<String, dynamic>> fetchUserInfo(String idToken) async {
    try {
      final response = await _dioService.post(
        '/api/auth/social-auth/',
        data: {
          'id_token': idToken,
        },
      );

      print('✅ response: ${response.data}');

      return response.data;
    } catch (e) {
      print('Error fetching user info: $e');
      rethrow;
    }
  }

  // 토큰 유효성 검증을 위한 메서드 추가
  Future<bool> validateToken(String idToken) async {
    try {
      final response = await _dioService.post(
        '/api/auth/validate-token/',
        data: {
          'id_token': idToken,
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }
}
