import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/database_service.dart';
import '../../community/models/character.dart';

final databaseProvider = Provider((ref) => DatabaseService());

final chatListProvider = FutureProvider<List<ChatListItem>>((ref) async {
  final dbService = ref.read(databaseProvider);
  final rawList = await dbService.getChatList();
  return rawList.map((map) {
    final character = Character.fromMap(map);
    final lastMessage = map['lastMessage'] as String? ?? '';
    final lastMessageTime = map['lastMessageTime'] != null
        ? DateTime.parse(map['lastMessageTime'] as String)
        : DateTime.now();
    return ChatListItem(
      character: character,
      lastMessage: lastMessage,
      lastMessageTime: lastMessageTime,
    );
  }).toList();
});

class ChatListItem {
  final Character character;
  final String lastMessage;
  final DateTime lastMessageTime;

  ChatListItem({
    required this.character,
    required this.lastMessage,
    required this.lastMessageTime,
  });
}