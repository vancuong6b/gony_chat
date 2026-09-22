class Creator {
  final String id;
  final String name;
  final String avatarUrl;
  final String bio;
  final String stats;
  final int rank;
  final List<String> featuredImages;

  Creator({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.bio,
    required this.stats,
    required this.rank,
    required this.featuredImages,
  });
}
