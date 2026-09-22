class Post {
  final String id;
  final String imageUrl;
  final String authorName;
  final String authorAvatarUrl;
  final String likes;
  final double aspectRatio;

  Post({
    required this.id,
    required this.imageUrl,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.likes,
    this.aspectRatio = 1.0,
  });
}
