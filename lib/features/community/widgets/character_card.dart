import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/character.dart';

class CharacterCard extends ConsumerWidget {
  final Character character;
  final bool showDescription;
  final bool isMyCharacter;

  const CharacterCard({
    super.key,
    required this.character,
    this.showDescription = true,
    this.isMyCharacter = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/character-detail', extra: character),
      child: Container(
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
            // Ảnh nhân vật (tỉ lệ 1:1, bo góc trên)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1,
                child: _buildImageWidget(),
              ),
            ),
            // Nội dung bên dưới ảnh
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hàng 1: Tên nhân vật (không có ngôi sao ở đây, vì ảnh không có)
                  Text(
                    character.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // Hàng 2: Wrap chứa "Chip", số tin nhắn, các tag
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('Chip ${character.chatCount}', isGrey: false),
                      ...character.tags.take(3).map((tag) => _buildChip(tag)),
                      if (character.tags.length < 3 && character.personality != null)
                        _buildChip(character.personality!),
                    ].take(4).toList(),
                  ),
                  const SizedBox(height: 12),

                  // Hàng 3: Mô tả ngắn
                  if (showDescription && character.description.isNotEmpty)
                    Text(
                      character.description,
                      style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 14),

                  // Hàng 4: Nút "Trò chuyện"
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => context.push('/chat-detail', extra: character),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF85A1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text('Trò chuyện', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip(String label, {bool isGrey = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isGrey ? Colors.grey.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isGrey ? Colors.black54 : Colors.black87,
        ),
      ),
    );
  }

  Widget _buildImageWidget() {
    if (character.imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: character.imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: Colors.grey.shade100),
        errorWidget: (_, __, ___) => Container(color: Colors.grey.shade300, child: const Icon(Icons.error)),
      );
    } else {
      return Image.file(
        File(character.imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
      );
    }
  }
}