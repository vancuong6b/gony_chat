import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../community/models/character.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';
import '../../community/providers/character_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Character character;

  const ChatScreen({super.key, required this.character});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  int _lastMessageCount = 0;

  // Số dư "Quen" tạm thời để hiển thị, sau này có thể lấy từ provider
  int quenBalance = 1250;

  void _sendMessage() {
    if (_controller.text.isEmpty) return;
    ref.read(chatHistoryProvider(widget.character.id).notifier).sendMessage(_controller.text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  Future<void> _deleteCharacter() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Xóa nhân vật'),
        content: Text('Bạn có chắc muốn xóa "${widget.character.name}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(characterListProvider.notifier).deleteCharacter(widget.character.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(chatHistoryProvider(widget.character.id));
    if (_lastMessageCount != messages.length) {
      _lastMessageCount = messages.length;
      _scrollToBottom();
    }

    final character = widget.character;

    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // === BACKGROUND: Ảnh nhân vật, KHÔNG blur, chỉ có dark overlay ===
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: character.imageUrl.startsWith('http')
                      ? NetworkImage(character.imageUrl)
                      : FileImage(File(character.imageUrl)) as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.4),
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // === NỘI DUNG CHÍNH ===
          SafeArea(
            child: Column(
              children: [
                // === TOP BAR (Glassmorphism nhẹ) ===
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    border: Border(
                      bottom: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                    ),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          character.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.diamond, color: Colors.cyanAccent, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '$quenBalance',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add, color: Colors.white, size: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'delete') _deleteCharacter();
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Xóa nhân vật'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // === VÙNG CHAT ===
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    children: [
                      // Giới thiệu (full width)
                      if (character.introduction != null && character.introduction!.isNotEmpty)
                        _buildIntroCard(character.introduction!),
                      const SizedBox(height: 12),

                      // Lời mở đầu (full width)
                      if (character.scenario.isNotEmpty)
                        _buildIntroCard(character.scenario),
                      const SizedBox(height: 12),

                      // Lời chào (2/3 chiều rộng, màu trắng, chữ đen)
                      if (character.greeting != null && character.greeting!.isNotEmpty)
                        _buildGreetingCard(character.greeting!),
                      const SizedBox(height: 20),

                      // Các tin nhắn (tin nhắn AI sẽ có style riêng)
                      ...messages.map((msg) => MessageBubble(message: msg)).toList(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),

                // === KHUNG NHẬP TIN NHẮN ===
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Nhập tin nhắn...',
                            hintStyle: TextStyle(color: Colors.grey),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                          onSubmitted: (_) => _sendMessage(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _sendMessage,
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.cyanAccent, Colors.blueAccent],
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.send, color: Colors.white, size: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card giới thiệu / lời mở đầu (full width, nền đen mờ, chữ trắng)
  Widget _buildIntroCard(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.5),
      ),
    );
  }

  // Card lời chào (2/3 chiều rộng, màu trắng, chữ đen)
  Widget _buildGreetingCard(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.65, // 2/3 màn hình
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 14, height: 1.4),
        ),
      ),
    );
  }
}