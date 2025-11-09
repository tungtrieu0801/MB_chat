class ProfileDetailModel {
  final String id;
  final String username;
  final String fullname;
  final String email;
  final String phoneNumber;
  final String avatar;
  final String role;
  final List<String> friends;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProfileDetailModel({
    required this.id,
    required this.username,
    required this.fullname,
    required this.email,
    required this.phoneNumber,
    required this.avatar,
    required this.role,
    required this.friends,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileDetailModel.fromJson(Map<String, dynamic> json) {
    return ProfileDetailModel(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      fullname: json['fullname'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      avatar: json['avatar'] ?? '',
      role: json['role'] ?? '',
      friends: json['friends'] != null
          ? List<String>.from(json['friends'])
          : [],
      isActive: json['isActive'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullname': fullname,
      'email': email,
      'phoneNumber': phoneNumber,
      'avatar': avatar,
      'role': role,
      'friends': friends,
      'isActive': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
