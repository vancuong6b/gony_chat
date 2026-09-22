import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message.dart';
import '../../../core/services/database_service.dart';
import '../../../core/services/ai_service.dart';
import '../../community/providers/character_provider.dart';

final aiServiceProvider = Provider((ref) => AiService());

final chatHistoryProvider = StateNotifierProvider.family<ChatHistoryNotifier, List<Message>, String>((ref, charId) {
  final dbService = ref.watch(databaseProvider);
  final aiService = ref.watch(aiServiceProvider);
  final characters = ref.watch(characterListProvider);
  final character = characters.firstWhere((c) => c.id == charId);
  final characterListNotifier = ref.read(characterListProvider.notifier);
  return ChatHistoryNotifier(dbService, aiService, character, characterListNotifier);
});

class ChatHistoryNotifier extends StateNotifier<List<Message>> {
  final DatabaseService _dbService;
  final AiService _aiService;
  final dynamic _character;
  final CharacterListNotifier _characterListNotifier;

  ChatHistoryNotifier(this._dbService, this._aiService, this._character, this._characterListNotifier) : super([]) {
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    state = await _dbService.getMessages(_character.id);
  }

  void sendMessage(String text) async {
    final userMessage = Message(
      id: DateTime.now().toString(),
      charId: _character.id,
      text: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    await _dbService.insertMessage(userMessage);
    state = [...state, userMessage];

    final aiResponse = await _aiService.getResponse(
      character: _character,
      history: state.sublist(0, state.length - 1),
      userMessage: text,
    );

    final reply = Message(
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      charId: _character.id,
      text: aiResponse,
      isUser: false,
      timestamp: DateTime.now(),
    );

    await _dbService.insertMessage(reply);
    state = [...state, reply];

    await _characterListNotifier.incrementChatCount(_character.id);
  }
}