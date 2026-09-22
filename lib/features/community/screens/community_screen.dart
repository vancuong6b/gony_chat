import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../../core/utils/mock_data.dart';
import '../widgets/post_card.dart';
import '../widgets/premium_character_card.dart';
import '../widgets/creator_ranking_card.dart';
import '../../search/screens/search_screen.dart';
import '../../search/screens/tag_search_screen.dart';
import '../providers/character_provider.dart';
import '../models/character.dart';  // THÊM IMPORT NÀY

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  bool _isTagsExpanded = false;
  int _activeMainTab = 1;
  int _activeCategoryTab = 0;
  int _activeSubTab = 0;
  String _activeSort = 'Xu hướng';
  String _activeRankingSort = 'Bảng xếp hạng tháng';

  final List<String> _suggestTags = ['Phụ nữ chín', 'Stalker', 'Tội lỗi', 'Bạn gái'];

  // Bỏ danh sách _personalityTags vì không dùng đến (hoặc giữ lại nhưng không lỗi)
  // Nếu muốn giữ thì thêm, nhưng hiện tại không dùng, nên xóa để tránh cảnh báo.

  void _navigateToTagSearch(String tag) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TagSearchScreen(tag: tag)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            _buildMainTab('Cộng đồng', isActive: _activeMainTab == 0, onTap: () => setState(() => _activeMainTab = 0)),
            const SizedBox(width: 20),
            _buildMainTab('Nhân vật', isActive: _activeMainTab == 1, onTap: () => setState(() => _activeMainTab = 1)),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.search, color: Colors.grey),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SearchScreen()),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          _activeMainTab == 0 ? _buildCommunityTab() : _buildCharacterTab(),
          if (_activeMainTab == 1 && _activeCategoryTab == 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildMyRankingStatus(),
            ),
        ],
      ),
    );
  }

  // --- TAB CỘNG ĐỒNG (giữ nguyên) ---
  Widget _buildCommunityTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              _buildSubTab('Thư viện', index: 0),
              _buildSubTab('Phòng Chat', index: 1),
              _buildSubTab('Mô hình', index: 2),
              const Spacer(),
              _buildSortDropdown(),
            ],
          ),
        ),
        Expanded(
          child: MasonryGridView.count(
            padding: const EdgeInsets.all(12),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: mockPosts.length,
            itemBuilder: (context, index) {
              return PostCard(post: mockPosts[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSubTab(String label, {required int index}) {
    final isActive = _activeSubTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeSubTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSortDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) => setState(() => _activeSort = value),
      child: Row(
        children: [
          Text(_activeSort, style: const TextStyle(color: Colors.blue, fontSize: 13)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.blue, size: 16),
        ],
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Mới nhất', child: Text('Mới nhất')),
        const PopupMenuItem(value: 'Xu hướng', child: Text('Xu hướng')),
      ],
    );
  }

  // ========== TAB NHÂN VẬT ==========
  Widget _buildCharacterTab() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBanner(),
          const SizedBox(height: 16),
          _buildCategoryTabs(),
          const SizedBox(height: 16),
          if (_activeCategoryTab != 2) _buildSuggestTagsRow(),
          const SizedBox(height: 12),
          _buildGridContent(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              'https://picsum.photos/seed/manual_qa_v3/800/350',
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 16,
            bottom: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'MiraiMind FEEDBACK',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: Row(
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == 0 ? Colors.white : Colors.white.withValues(alpha: 0.5),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildRoundedTab('Thẻ Phổ biến', 0),
          const SizedBox(width: 12),
          _buildRoundedTab('Bảng xếp hạng', 1),
          const SizedBox(width: 12),
          _buildRoundedTab('Nhân vật Đặc sắc', 2),
        ],
      ),
    );
  }

  Widget _buildRoundedTab(String label, int index) {
    final isActive = _activeCategoryTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _activeCategoryTab = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? Colors.blue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey.shade700,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestTagsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Đề xuất',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _suggestTags.map((tag) {
                  return GestureDetector(
                    onTap: () => _navigateToTagSearch(tag),
                    child: Container(
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (_activeCategoryTab == 0)
            IconButton(
              icon: Icon(_isTagsExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
              onPressed: () => setState(() => _isTagsExpanded = !_isTagsExpanded),
            ),
        ],
      ),
    );
  }

  Widget _buildGridContent() {
    final characterList = ref.watch(characterListProvider);
    final isRankingTab = _activeCategoryTab == 1;
    final isPremiumTab = _activeCategoryTab == 2;

    if (isRankingTab) {
      return _buildRankingContent();
    }

    List<Character> filteredList;
    if (isPremiumTab) {
      filteredList = characterList.where((c) => c.isPremium).toList();
    } else {
      filteredList = characterList;
    }

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      crossAxisCount: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final character = filteredList[index];
        if (isPremiumTab) {
          return PremiumCharacterCard(character: character);
        }
        return _CharacterGridCard(character: character);
      },
    );
  }

  Widget _buildRankingContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              const Text('Người tạo', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 15)),
              const Spacer(),
              _buildRankingSortDropdown(),
            ],
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: mockCreators.length,
          itemBuilder: (context, index) {
            return CreatorRankingCard(creator: mockCreators[index]);
          },
        ),
      ],
    );
  }

  Widget _buildRankingSortDropdown() {
    return PopupMenuButton<String>(
      onSelected: (value) => setState(() => _activeRankingSort = value),
      child: Row(
        children: [
          Text(_activeRankingSort, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          const Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 16),
        ],
      ),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'Bảng xếp hạng tháng', child: Text('Bảng xếp hạng tháng')),
        const PopupMenuItem(value: 'Bảng xếp hạng tuần', child: Text('Bảng xếp hạng tuần')),
      ],
    );
  }

  Widget _buildMyRankingStatus() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          const Text('--', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(width: 15),
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.withValues(alpha: 0.2), width: 2),
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFF5F5F5),
              child: Icon(Icons.person, color: Colors.blue, size: 20),
            ),
          ),
          const SizedBox(width: 15),
          const Text('c', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.black87)),
          const Spacer(),
          const Text('60', style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildMainTab(String label, {required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.grey,
              fontSize: 18,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              margin: const EdgeInsets.only(top: 4),
              height: 3,
              width: 20,
              color: Colors.cyanAccent,
            ),
        ],
      ),
    );
  }
}

// ========== THẺ NHÂN VẬT MỚI ==========
class _CharacterGridCard extends StatelessWidget {
  final Character character;
  const _CharacterGridCard({required this.character});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 0.75,
              child: _buildImage(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        character.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.chat_bubble_outline, size: 10, color: Colors.grey),
                          const SizedBox(width: 2),
                          Text(
                            character.chatCount,
                            style: const TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  character.scenario,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    if (character.imageUrl.startsWith('http')) {
      return Image.network(
        character.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200),
      );
    } else {
      // Sử dụng `dart:io` File, đã import ở đầu file
      return Image.file(
        File(character.imageUrl),
        fit: BoxFit.cover,
        width: double.infinity,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200),
      );
    }
  }
}