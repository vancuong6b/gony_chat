import 'dart:ui';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../models/character.dart';
import '../providers/character_provider.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  late PageController _pageController;
  double _currentPage = 0.0;

  final List<List<double>> _colorMatrices = [
    [1.5, 0.5, 0.5, 0, 50, 0.5, 1.0, 0.5, 0, 20, 0.5, 0.5, 1.0, 0, 20, 0, 0, 0, 1, 0],
    [0.8, 0.4, 0.4, 0, 0, 0.4, 1.5, 0.4, 0, 50, 0.4, 0.4, 1.5, 0, 50, 0, 0, 0, 1, 0],
    [1.4, 0.4, 0, 0, 40, 1.4, 0.4, 0, 0, 40, 0, 0, 1.0, 0, 0, 0, 0, 0, 1, 0],
    [1.2, 0.4, 1.4, 0, 50, 0.4, 1.0, 0.4, 0, 20, 1.2, 0.4, 1.8, 0, 80, 0, 0, 0, 1, 0],
    [1.6, 0.6, 0.4, 0, 60, 0.6, 1.2, 0.4, 0, 40, 0.4, 0.4, 1.0, 0, 20, 0, 0, 0, 1, 0],
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9)
      ..addListener(() {
        setState(() {
          _currentPage = _pageController.page ?? 0.0;
        });
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final characterList = ref.watch(characterListProvider);

    if (characterList.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
            child: Text(
                "Chưa có nhân vật nào.\nHãy nhấn '+' để tạo mới!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16)
            )
        ),
      );
    }

    int currentIndex = _currentPage.round().clamp(0, characterList.length - 1);
    final currentCharacter = characterList[currentIndex];
    final currentMatrix = _colorMatrices[currentIndex % _colorMatrices.length];

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 600),
              child: Container(
                key: ValueKey('bg_${currentCharacter.id}'),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _buildImageProvider(currentCharacter.imageUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.matrix(currentMatrix),
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.white.withValues(alpha: 0.15)),
                ),
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: characterList.length,
            itemBuilder: (context, index) {
              double relativePosition = index - _currentPage;
              double scale = (1 - (relativePosition.abs() * 0.1)).clamp(0.9, 1.0);
              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _CharacterFeedItem(
                    character: characterList[index],
                    relativePosition: relativePosition,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ImageProvider _buildImageProvider(String url) {
    if (url.startsWith('http')) {
      return NetworkImage(url);
    } else {
      return FileImage(File(url));
    }
  }
}

class _CharacterFeedItem extends ConsumerStatefulWidget {
  final Character character;
  final double relativePosition;

  const _CharacterFeedItem({
    required this.character,
    required this.relativePosition,
  });

  @override
  ConsumerState<_CharacterFeedItem> createState() => _CharacterFeedItemState();
}

class _CharacterFeedItemState extends ConsumerState<_CharacterFeedItem> {
  bool _isExpanded = false; // for description

  @override
  Widget build(BuildContext context) {
    double contentAlpha = (1 - (widget.relativePosition.abs() * 0.5)).clamp(0.5, 1.0);
    final character = widget.character;

    return RepaintBoundary(
      child: Center(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4 * contentAlpha),
                blurRadius: 30,
                spreadRadius: 2,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Stack(
              children: [
                Positioned.fill(
                  child: character.imageUrl.startsWith('http')
                      ? Image.network(
                    character.imageUrl,
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(alpha: 1.0 - contentAlpha),
                    colorBlendMode: BlendMode.darken,
                  )
                      : Image.file(
                    File(character.imageUrl),
                    fit: BoxFit.cover,
                    color: Colors.black.withValues(alpha: 1.0 - contentAlpha),
                    colorBlendMode: BlendMode.darken,
                  ),
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.1 * contentAlpha),
                          Colors.black.withValues(alpha: 0.8 * contentAlpha),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Spacer(),
                      // ========== HÀNG 1: Tên nhân vật + yêu thích ==========
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              character.name,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: contentAlpha),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              ref.read(characterListProvider.notifier).toggleFavorite(character.id);
                            },
                            child: ShaderMask(
                              shaderCallback: (bounds) => character.isFavorite
                                  ? const LinearGradient(colors: AppColors.mainGradient).createShader(bounds)
                                  : LinearGradient(
                                colors: [Colors.white.withValues(alpha: contentAlpha), Colors.white.withValues(alpha: contentAlpha)],
                              ).createShader(bounds),
                              child: Icon(
                                character.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // ========== HÀNG 2: Tên người tạo + Chip tin nhắn + Tag (wrap) ==========
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          // Tên người tạo (in đậm hơn)
                          _buildChip(
                            label: character.creatorName,
                            alpha: contentAlpha,
                            isBold: true,
                          ),
                          // Chip số tin nhắn
                          _buildChip(
                            label: '💬 ${character.chatCount}',
                            alpha: contentAlpha,
                          ),
                          // Các tag tính cách: personality + tags (lấy tối đa 4 tag)
                          if (character.personality != null && character.personality!.isNotEmpty)
                            _buildChip(label: character.personality!, alpha: contentAlpha),
                          ...character.tags.map((tag) => _buildChip(label: tag, alpha: contentAlpha)),
                        ].take(6).toList(),
                      ),
                      const SizedBox(height: 16),
                      // ========== HÀNG 3: Mô tả ngắn (có thể mở rộng) ==========
                      if (character.description.isNotEmpty) ...[
                        Text(
                          character.description,
                          maxLines: _isExpanded ? null : 3,
                          overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9 * contentAlpha),
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                        if (_isDescriptionOverflow(character.description))
                          GestureDetector(
                            onTap: () => setState(() => _isExpanded = !_isExpanded),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                _isExpanded ? 'Thu gọn' : 'Xem thêm',
                                style: TextStyle(
                                  color: Colors.blueAccent.withValues(alpha: contentAlpha),
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                      ],
                      const SizedBox(height: 24),
                      // ========== HÀNG 4: Nút Trò chuyện ==========
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.mainGradient.map((c) => c.withValues(alpha: contentAlpha)).toList(),
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            context.push('/chat-detail', extra: character);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            disabledBackgroundColor: Colors.transparent,
                          ),
                          child: Text(
                            'Trò chuyện',
                            style: TextStyle(
                              color: Colors.black.withValues(alpha: contentAlpha),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip({required String label, required double alpha, bool isBold = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: alpha),
          fontSize: 13,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  bool _isDescriptionOverflow(String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 14, height: 1.4),
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 80);
    return textPainter.didExceedMaxLines;
  }
}