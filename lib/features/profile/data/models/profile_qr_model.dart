class ProfileQrModel {
  final String fullName;
  final String avatarUrl;

  ProfileQrModel({
    required this.fullName,
    required this.avatarUrl,
  });

  factory ProfileQrModel.fromJson(Map<String, dynamic> json) {
    return ProfileQrModel(
      fullName: json['fullName'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
    );
  }
}