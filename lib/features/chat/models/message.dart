class Message {
  final String id;
  final String charId; // Liên kết với nhân vật
  final String text;
  final bool isUser;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.charId,
    required this.text,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'charId': charId,
      'text': text,
      'isUser': isUser ? 1 : 0,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map['id'],
      charId: map['charId'],
      text: map['text'],
      isUser: map['isUser'] == 1,
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}
