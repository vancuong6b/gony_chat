import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../community/providers/character_provider.dart';
import '../../community/widgets/character_card.dart';
import '../../community/widgets/premium_character_card.dart';

class TagSearchScreen extends ConsumerWidget {
  final String tag;

  const TagSearchScreen({super.key, required this.tag});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allCharacters = ref.watch(characterListProvider);
    final filteredCharacters = allCharacters.where((char) {
      if (char.personality != null && char.personality!.toLowerCase().contains(tag.toLowerCase())) {
        return true;
      }
      if (char.tags.any((t) => t.toLowerCase().contains(tag.toLowerCase()))) {
        return true;
      }
      if (char.role.toLowerCase().contains(tag.toLowerCase())) {
        return true;
      }
      return false;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Kết quả cho: $tag',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: filteredCharacters.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy nhân vật nào',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: filteredCharacters.length,
        itemBuilder: (context, index) {
          final character = filteredCharacters[index];
          if (character.isPremium) {
            return PremiumCharacterCard(character: character);
          }
          return CharacterCard(character: character);
        },
      ),
    );
  }
}