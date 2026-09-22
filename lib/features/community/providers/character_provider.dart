import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/character.dart';
import '../../../core/services/database_service.dart';

final databaseProvider = Provider((ref) => DatabaseService());

final characterListProvider = StateNotifierProvider<CharacterListNotifier, List<Character>>((ref) {
  return CharacterListNotifier(ref.watch(databaseProvider));
});

class CharacterListNotifier extends StateNotifier<List<Character>> {
  final DatabaseService _dbService;

  CharacterListNotifier(this._dbService) : super([]) {
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    final dbChars = await _dbService.getCharacters();
    state = dbChars;
  }

  Future<void> addCharacter(Character character) async {
    final newChar = Character(
      id: character.id,
      name: character.name,
      imageUrl: character.imageUrl,
      description: character.description,
      creatorName: character.creatorName,
      creatorAvatarUrl: character.creatorAvatarUrl,
      chatCount: character.chatCount,
      tags: character.tags,
      role: character.role,
      scenario: character.scenario,
      isPremium: character.isPremium,
      starRating: character.starRating,
      background: character.background,
      relationship: character.relationship,
      personality: character.personality,
      plot: character.plot,
      appearance: character.appearance,
      identity: character.identity,
      ability: character.ability,
      introduction: character.introduction,
      greeting: character.greeting,
      isFavorite: false,
    );
    await _dbService.insertCharacter(newChar);
    state = [newChar, ...state];
  }

  Future<void> deleteCharacter(String charId) async {
    await _dbService.deleteCharacter(charId);
    state = state.where((c) => c.id != charId).toList();
  }

  Future<void> incrementChatCount(String charId) async {
    await _dbService.incrementChatCount(charId);
    final updatedList = state.map((c) {
      if (c.id == charId) {
        int current = int.tryParse(c.chatCount) ?? 0;
        int newCount = current + 1;
        return Character(
          id: c.id,
          name: c.name,
          imageUrl: c.imageUrl,
          description: c.description,
          creatorName: c.creatorName,
          creatorAvatarUrl: c.creatorAvatarUrl,
          chatCount: newCount.toString(),
          tags: c.tags,
          role: c.role,
          scenario: c.scenario,
          isPremium: c.isPremium,
          starRating: c.starRating,
          background: c.background,
          relationship: c.relationship,
          personality: c.personality,
          plot: c.plot,
          appearance: c.appearance,
          identity: c.identity,
          ability: c.ability,
          introduction: c.introduction,
          greeting: c.greeting,
          isFavorite: c.isFavorite,
        );
      }
      return c;
    }).toList();
    state = updatedList;
  }

  Future<void> toggleFavorite(String charId) async {
    final character = state.firstWhere((c) => c.id == charId);
    final newFavorite = !character.isFavorite;
    await _dbService.updateCharacterFavorite(charId, newFavorite);

    state = state.map((c) {
      if (c.id == charId) {
        return Character(
          id: c.id,
          name: c.name,
          imageUrl: c.imageUrl,
          description: c.description,
          creatorName: c.creatorName,
          creatorAvatarUrl: c.creatorAvatarUrl,
          chatCount: c.chatCount,
          tags: c.tags,
          role: c.role,
          scenario: c.scenario,
          isPremium: c.isPremium,
          starRating: c.starRating,
          background: c.background,
          relationship: c.relationship,
          personality: c.personality,
          plot: c.plot,
          appearance: c.appearance,
          identity: c.identity,
          ability: c.ability,
          introduction: c.introduction,
          greeting: c.greeting,
          isFavorite: newFavorite,
        );
      }
      return c;
    }).toList();
  }
}