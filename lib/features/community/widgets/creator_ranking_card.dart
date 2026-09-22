import 'package:flutter/material.dart';
import '../models/creator.dart';

class CreatorRankingCard extends StatelessWidget {
  final Creator creator;

  const CreatorRankingCard({super.key, required this.creator});

  @override
  Widget build(BuildContext context) {
    Color bgColor = Colors.white;
    if (creator.rank == 1) bgColor = const Color(0xFFFFFDE7);
    if (creator.rank == 2) bgColor = const Color(0xFFE3F2FD);
    if (creator.rank == 3) bgColor = const Color(0xFFFBE9E7);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildRankIcon(creator.rank),
              const SizedBox(width: 12),
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(creator.avatarUrl),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      creator.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      creator.bio,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                creator.stats,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: creator.featuredImages.map((imageUrl) => ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: MediaQuery.of(context).size.width * 0.2,
                height: 90,
                fit: BoxFit.cover,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRankIcon(int rank) {
    if (rank <= 3) {
      String emoji = '🥇';
      if (rank == 2) emoji = '🥈';
      if (rank == 3) emoji = '🥉';
      return Text(emoji, style: const TextStyle(fontSize: 20));
    }
    return Text(
      rank.toString(),
      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14),
    );
  }
}
