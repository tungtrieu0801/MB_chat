import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_endpoint.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoint.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  static Dio get instance {
    // Tránh thêm interceptor nhiều lần
    if (_dio.interceptors.whereType<AuthInterceptor>().isEmpty) {
      _dio.interceptors.add(AuthInterceptor());
    }

    // Thêm log interceptor
    _dio.interceptors.add(LogInterceptor(responseBody: true));

    return _dio;
  }
}

// Interceptor gắn token tự động
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token'); // key bạn lưu token sau login
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }
}
