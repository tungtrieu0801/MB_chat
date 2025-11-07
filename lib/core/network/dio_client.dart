import 'package:dio/dio.dart';

import '../../constants/api_endpoint.dart';

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

  // Có thể thêm interceptor chung
  static Dio get instance {
    _dio.interceptors.add(LogInterceptor(responseBody: true));
    return _dio;
  }
}
