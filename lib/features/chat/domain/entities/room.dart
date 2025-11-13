class Room {
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
  final DateTime? lastOnlineAt;

  const Room({
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
    required this.lastOnlineAt
  });
}
