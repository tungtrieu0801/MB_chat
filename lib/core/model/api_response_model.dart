class ApiResponse<T> {
  final int code;
  final String message;
  final T? data;
  final int? responseTimeMs;

  ApiResponse({
    required this.code,
    required this.message,
    this.data,
    this.responseTimeMs,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json,
      T Function(dynamic jsonT) fromJsonT) {
    return ApiResponse(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      responseTimeMs: json['responseTimeMs'],
    );
  }

  Map<String, dynamic> toJson(Map<String, dynamic> Function(T) toJsonT) {
    return {
      'code': code,
      'message': message,
      'data': data != null ? toJsonT(data as T) : null,
      'responseTimeMs': responseTimeMs,
    };
  }
}