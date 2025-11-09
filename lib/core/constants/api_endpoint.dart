class ApiEndpoint {
  static const String baseUrl = 'http://192.168.1.3:3000';

  static const String loginUrl = '$baseUrl/auth/login';

  static const String registerUrl = '$baseUrl/auth/register';

  static const String generatedQR = '$baseUrl/qrcode/generate';

  static const String getUserDetail = '$baseUrl/users/details';

  static const String getListRoom = '$baseUrl/rooms';
  
}