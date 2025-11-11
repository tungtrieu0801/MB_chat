class ApiEndpoint {
  static const String baseUrl = 'http://10.141.20.160:3000';

  static const String socketUrl = 'http://10.141.20.160:3000';

  static const String loginUrl = '$baseUrl/auth/login';

  static const String registerUrl = '$baseUrl/auth/register';

  static const String generatedQR = '$baseUrl/qrcode/generate';

  static const String getUserDetail = '$baseUrl/users/details';

  static const String getListRoom = '$baseUrl/rooms';

  static String getListMessageInRoom(String roomId, int page, int limit) =>
      '$baseUrl/messages/room/$roomId?page=$page&limit=$limit';
  
}