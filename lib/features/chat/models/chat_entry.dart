class ChatEntry {
  final String id;
  final String name;
  final String avatarUrl;
  final String lastMessage;
  final String time;
  final String relationshipStatus;
  final String hotLevel;
  final bool isBoldMessage;
  final String charId;

  ChatEntry({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.lastMessage,
    required this.time,
    required this.relationshipStatus,
    required this.hotLevel,
    this.isBoldMessage = false,
    required this.charId,
  });
}
