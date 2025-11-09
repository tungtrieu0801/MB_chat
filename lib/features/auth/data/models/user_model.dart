import 'dart:convert';
import '../../domain/entities/user.dart';

class LoginResponseModel {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String accessToken;
  final String avatar;

  LoginResponseModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.accessToken,
    required this.avatar,
  });

  /// Parse JSON trực tiếp user object, không check `data`
  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      accessToken: json['accessToken'] ?? '',
      avatar: json['avatar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'phoneNumber': phoneNumber,
    'accessToken': accessToken,
    'avatar': avatar,
  };

  /// Dùng để lưu vào SharedPreferences
  String toJsonString() => jsonEncode(toJson());

  /// Dùng để đọc lại từ SharedPreferences
  factory LoginResponseModel.fromJsonString(String jsonString) =>
      LoginResponseModel.fromJson(jsonDecode(jsonString));

  /// Convert sang domain entity
  User toEntity() => User(
    id: id,
    username: username,
    email: email,
    phoneNumber: phoneNumber,
    accessToken: accessToken,
    avatar: avatar,
  );

  /// Convert từ domain entity sang model
  factory LoginResponseModel.fromEntity(User user) => LoginResponseModel(
    id: user.id,
    username: user.username,
    email: user.email,
    phoneNumber: user.phoneNumber,
    accessToken: user.accessToken,
    avatar: user.avatar,
  );
}
