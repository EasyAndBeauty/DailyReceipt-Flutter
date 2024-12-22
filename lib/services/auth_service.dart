import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
 // localhost 대신 실제 IP 사용 (테스트 시에는 localhost로 시작)
  final String baseUrl = 'http://localhost:8000/api/auth';

  Future<Map<String, dynamic>> fetchUserInfo(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/social-auth/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_token': idToken,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final error = jsonDecode(response.body)['error'];
        throw Exception('Failed to fetch user info: $error');
      }
    } catch (e) {
      print('Error fetching user info: $e');
      rethrow;
    }
  }

  // 토큰 유효성 검증을 위한 메서드 추가
  Future<bool> validateToken(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/validate-token/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_token': idToken,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error validating token: $e');
      return false;
    }
  }
}
