import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../community/providers/character_provider.dart';
import '../../community/models/character.dart';
import '../../community/widgets/character_card.dart';
import '../../community/widgets/premium_character_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;

  final List<String> _trendingSearches = const [
    'Chị gái', 'Futa', 'Chị em kế', 'BL', 'Kẻ bắt nạt',
    'Bạn bè', 'Con gái', 'Femboy', 'Mèo', 'Sói',
    'Nhỏ bé', 'Nô lệ', 'Của bạn', 'Milf', 'S',
    'Lesbian', 'Mạnh mẽ', 'Bạn cùng phòng',
    'Cô gái sói', 'Yandere',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
        _isSearching = _searchQuery.isNotEmpty;
      });
    });
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _searchQuery = widget.initialQuery!;
      _isSearching = true;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Character> _filterCharacters(List<Character> characters, String query) {
    if (query.isEmpty) return [];
    final lowerQuery = query.toLowerCase();
    return characters.where((char) {
      if (char.name.toLowerCase().contains(lowerQuery)) return true;
      if (char.description.toLowerCase().contains(lowerQuery)) return true;
      if (char.personality != null && char.personality!.toLowerCase().contains(lowerQuery)) return true;
      if (char.tags.any((tag) => tag.toLowerCase().contains(lowerQuery))) return true;
      if (char.role.toLowerCase().contains(lowerQuery)) return true;
      return false;
    }).toList();
  }

  void _searchByTag(String tag) {
    setState(() {
      _searchController.text = tag;
      _searchQuery = tag;
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allCharacters = ref.watch(characterListProvider);
    final filteredCharacters = _filterCharacters(allCharacters, _searchQuery);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: widget.initialQuery == null,
                        style: const TextStyle(color: Colors.black, fontSize: 16),
                        decoration: const InputDecoration(
                          hintText: 'Tìm kiếm ở đây',
                          prefixIcon: Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      'Hủy',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _isSearching
                  ? _buildSearchResults(filteredCharacters)
                  : _buildTrendingSection(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.grey.withValues(alpha: 0.5), size: 18),
              const SizedBox(width: 4),
              const Text(
                'Tìm kiếm thịnh hành',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 12,
            children: _trendingSearches.map((tag) => GestureDetector(
              onTap: () => _searchByTag(tag),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )).toList(),
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.grey.withValues(alpha: 0.5), size: 18),
              const SizedBox(width: 4),
              const Text(
                'Mẹo tìm kiếm',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Hãy thử mô tả các đặc điểm hoặc tính năng của nhân vật - không chỉ là từ khóa',
            style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults(List<Character> results) {
    if (results.isEmpty && _searchQuery.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy nhân vật nào',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Hãy thử từ khóa khác',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final character = results[index];
        if (character.isPremium) {
          return PremiumCharacterCard(character: character);
        }
        return CharacterCard(character: character);
      },
    );
  }
}