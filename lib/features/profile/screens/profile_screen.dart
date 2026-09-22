import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../community/providers/character_provider.dart';
import '../../community/widgets/character_card.dart';
import '../../community/widgets/premium_character_card.dart';
import '../../community/models/character.dart';
import 'settings_screen.dart';
// ... (nội dung như đã gửi)

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  int _activeTab = 0; // 0: Nhân vật, 1: Yêu thích, 2: Ảnh, 3: Kịch bản, 4: Chat nhóm

  @override
  Widget build(BuildContext context) {
    final characterList = ref.watch(characterListProvider);
    final favoriteCount = characterList.where((c) => c.isFavorite).length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFFE0F7FA).withValues(alpha: 0.5),
              Colors.white,
            ],
            stops: const [0.0, 0.3],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                _buildUserInfo(),
                const SizedBox(height: 24),
                _buildMainCards(),
                const SizedBox(height: 20),
                _buildStatsRow(favoriteCount),
                const SizedBox(height: 24),
                _buildTabs(),
                const SizedBox(height: 16),
                _buildCharacterList(characterList),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildSocialIcon(Icons.discord, Colors.black),
          const SizedBox(width: 16),
          _buildSocialIcon(Icons.play_circle_fill, Colors.red),
          const SizedBox(width: 16),
          _buildSocialIcon(Icons.close, Colors.black),
          const Spacer(),
          const Icon(Icons.nightlight_round, color: Colors.black54, size: 20),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black54, size: 20),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, Color color) {
    return Icon(icon, color: color, size: 24);
  }

  Widget _buildUserInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.yellow.shade200, width: 3),
                ),
              ),
              const CircleAvatar(
                radius: 38,
                backgroundColor: Color(0xFFE1F5FE),
                child: Icon(Icons.face, size: 40, color: Colors.blueAccent),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'c',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ],
                ),
                const Text(
                  'UID: G16015508',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.yellow.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt, size: 12, color: Colors.orange),
                      SizedBox(width: 4),
                      Text('A Dreamy Getaway', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.brown)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_ios, size: 10, color: Colors.brown),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.edit_outlined, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildMainCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE1F5FE), Color(0xFFE8EAF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Konpeito',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
                  ),
                  const Spacer(),
                  const Row(
                    children: [
                      Text(
                        '450',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.black),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.filter_vintage, color: Colors.pinkAccent, size: 20),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFF81D4FA), Color(0xFFB39DDB)]),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Thêm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 140,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFF3E0), Color(0xFFFCE4EC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'MMPro+',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFFE91E63)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Bộ nhớ vĩnh viễn, không quảng cáo và nhiều đặ...',
                    style: TextStyle(fontSize: 11, color: Colors.black87, fontWeight: FontWeight.w600),
                    maxLines: 2,
                  ),
                  const Spacer(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFF48FB1), Color(0xFFFF4081)]),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: const Text('Đăng ký', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(int favoriteCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatItem(Icons.chat_bubble_outline, '101', 'Lịch sử', Colors.blue),
          _buildStatItem(Icons.star_border, favoriteCount.toString(), 'Yêu thích', Colors.pinkAccent),
          _buildStatItem(Icons.account_balance_wallet_outlined, '130', 'Thu nhập', Colors.orange),
          _buildStatItem(Icons.bookmark_border_rounded, '23', 'Đã thu thập', Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String val, String label, Color color) {
    return Container(
      width: (MediaQuery.of(context).size.width - 64) / 4,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(
            val,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black),
          ),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTabItem('Nhân vật (19)', 0),
            const SizedBox(width: 16),
            _buildTabItem('Yêu thích', 1),
            const SizedBox(width: 16),
            _buildTabItem('Ảnh', 2),
            const SizedBox(width: 16),
            _buildTabItem('Kịch bản (1)', 3),
            const SizedBox(width: 16),
            _buildTabItem('Chat nhóm', 4),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String label, int index) {
    bool isActive = _activeTab == index;
    return GestureDetector(
      onTap: () => setState(() => _activeTab = index),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              fontSize: 15,
              color: isActive ? Colors.black : Colors.grey,
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

  Widget _buildCharacterList(List<Character> allCharacters) {
    final List<Character> displayList;
    if (_activeTab == 1) {
      displayList = allCharacters.where((c) => c.isFavorite).toList();
    } else if (_activeTab == 0) {
      displayList = allCharacters;
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Text('Tính năng đang phát triển', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Nhân vật trả phí', style: TextStyle(fontSize: 12, color: Colors.black87)),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.grey),
                    SizedBox(width: 8),
                    Text('Tạo nhân vật của tôi', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500)),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4FC3F7),
                      borderRadius: BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(10)),
                    ),
                    child: Text('${allCharacters.length}/50', style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (displayList.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Text('Chưa có nhân vật nào', style: TextStyle(color: Colors.grey)),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: displayList.length,
              itemBuilder: (context, index) {
                final character = displayList[index];
                if (character.isPremium) {
                  return PremiumCharacterCard(
                    character: character,
                    showDescription: false,
                    isMyCharacter: true,
                  );
                }
                return CharacterCard(
                  character: character,
                  showDescription: false,
                  isMyCharacter: true,
                );
              },
            ),
        ],
      ),
    );
  }
}