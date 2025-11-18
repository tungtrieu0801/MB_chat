import 'package:mobile_trip_togethor/features/chat/domain/entities/user_chat.dart';

class UserChatModel {
  final String id;
  final String fullname;
  final String? avatar;

  UserChatModel({
    required this.id,
    required this.fullname,
    this.avatar,
  });

  factory UserChatModel.fromJson(Map<String, dynamic> json) {
    return UserChatModel(
      id: json['_id'],
      fullname: json['fullname'],
      avatar: json['avatar'],
    );
  }

  UserChat toEntity() {
    return UserChat(
      id: id,
      fullname: fullname,
      avatar: avatar,
    );
  }
}