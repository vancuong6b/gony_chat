import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/chat_list_provider.dart';
import '../../profile/screens/notification_settings.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatListAsync = ref.watch(chatListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text('Trò chuyện', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Colors.black),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationSettingsScreen())),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _topIcon(Icons.style_rounded, 'Sáng tạo...', const Color(0xFFFCE4EC), Colors.pinkAccent),
                _topIcon(Icons.person_add_alt_1_rounded, 'Dòng thời...', const Color(0xFFE8F5E9), Colors.green),
                _topIcon(Icons.chat_bubble_rounded, 'Bình luận', const Color(0xFFFFFDE7), Colors.orangeAccent),
                _topIcon(Icons.notifications_rounded, 'Thông báo', const Color(0xFFE3F2FD), Colors.blueAccent),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF5F5F5)),
          Expanded(
            child: chatListAsync.when(
              data: (list) {
                if (list.isEmpty) return const Center(child: Text('Chưa có tin nhắn nào'));
                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1, indent: 80, color: Color(0xFFF5F5F5)),
                  itemBuilder: (context, index) {
                    final item = list[index];
                    final char = item.character;
                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(char.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey)),
                      ),
                      title: Row(
                        children: [
                          Expanded(child: Text(char.name, style: const TextStyle(fontWeight: FontWeight.bold))),
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
                            child: Text('Chip ${char.chatCount}', style: const TextStyle(fontSize: 11)),
                          ),
                        ],
                      ),
                      subtitle: Text(item.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Text(_formatTime(item.lastMessageTime), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                      onTap: () => context.push('/chat-detail', extra: char),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Lỗi: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topIcon(IconData icon, String label, Color bg, Color color) {
    return Column(
      children: [
        Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(15)), child: Icon(icon, color: color, size: 28)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black87)),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    if (time.day == now.day && time.month == now.month && time.year == now.year) {
      return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
    }
    return '${time.day}/${time.month}';
  }
}