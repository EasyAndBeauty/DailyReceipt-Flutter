import 'package:daily_receipt/services/token_service.dart';
import 'package:dio/dio.dart';

class DioService {
  late final Dio _dio;
  final TokenService _tokenService;

  DioService({required String baseUrl, required TokenService tokenService})
      : _tokenService = tokenService {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: 'application/json',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 3),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequest,
        onError: _onError,
      ),
    );
  }

  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // Firebase 토큰 가져오기
      final token = await _tokenService.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      return handler.next(options);
    } catch (e) {
      return handler.reject(
        DioException(
          requestOptions: options,
          error: '토큰 처리 중 오류 발생: $e',
        ),
      );
    }
  }

  Future<void> _onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    if (error.response?.statusCode == 401) {
      try {
        // 토큰 리프레시 시도
        final newToken = await _tokenService.getToken(forceRefresh: true);
        if (newToken != null) {
          // 기존 요청에 새 토큰 적용
          error.requestOptions.headers['Authorization'] = 'Bearer $newToken';
          // 요청 재시도
          final response = await _dio.fetch(error.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        return handler.reject(error);
      }
    }
    return handler.reject(error);
  }

  // API 메서드들
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.get<T>(
      path,
      queryParameters: queryParameters,
    );
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    return await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
    );
  }
}