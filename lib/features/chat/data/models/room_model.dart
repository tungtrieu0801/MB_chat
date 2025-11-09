class ChatRoomModel {
  final String id;
  final String roomSingleId;
  final String name;
  final String description;
  final bool isGroup;
  final List<String> memberIds;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final String createdBy;
  final String? avatar;
  final List<String> pinnedBy;
  final Map<String, int> unreadCounts;
  final String status;

  ChatRoomModel({
    required this.id,
    required this.roomSingleId,
    required this.name,
    required this.description,
    required this.isGroup,
    required this.memberIds,
    required this.lastMessage,
    required this.lastMessageAt,
    required this.createdBy,
    required this.avatar,
    required this.pinnedBy,
    required this.unreadCounts,
    required this.status,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'] as String,
      roomSingleId: json['roomSingleId'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      isGroup: json['isGroup'] as bool? ?? false,
      memberIds: List<String>.from(json['memberIds'] ?? []),
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'])
          : null,
      createdBy: json['createdBy'] as String? ?? '',
      avatar: json['avatar'] as String?,
      pinnedBy: List<String>.from(json['pinnedBy'] ?? []),
      unreadCounts: Map<String, int>.from(json['unreadCounts'] ?? {}),
      status: json['status'] as String? ?? 'active',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roomSingleId': roomSingleId,
      'name': name,
      'description': description,
      'isGroup': isGroup,
      'memberIds': memberIds,
      'lastMessage': lastMessage,
      'lastMessageAt': lastMessageAt?.toIso8601String(),
      'createdBy': createdBy,
      'avatar': avatar,
      'pinnedBy': pinnedBy,
      'unreadCounts': unreadCounts,
      'status': status,
    };
  }
}
