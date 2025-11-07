import 'dart:convert';

import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String username;
  final String email;
  final String phoneNumber;
  final String accessToken;
  final String avatar;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phoneNumber,
    required this.accessToken,
    required this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json; // Phòng trường hợp API trả thẳng data
    return UserModel(
      id: data['id'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      accessToken: data['accessToken'] ?? '',
      avatar: data['avatar'] ?? '',
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
  factory UserModel.fromJsonString(String jsonString) =>
      UserModel.fromJson(jsonDecode(jsonString));

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
  factory UserModel.fromEntity(User user) => UserModel(
    id: user.id,
    username: user.username,
    email: user.email,
    phoneNumber: user.phoneNumber,
    accessToken: user.accessToken,
    avatar: user.avatar,
  );
}
