class Character {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String creatorName;
  final String creatorAvatarUrl;
  final String chatCount;
  final List<String> tags;
  final String role;
  final String scenario;
  final bool isPremium;
  final int? starRating;

  final String? background;
  final String? relationship;
  final String? personality;
  final String? plot;
  final String? appearance;
  final String? identity;
  final String? ability;
  final String? introduction;
  final String? greeting;
  final bool isFavorite; // Thêm

  Character({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.creatorName,
    required this.creatorAvatarUrl,
    required this.chatCount,
    required this.tags,
    required this.role,
    required this.scenario,
    this.isPremium = false,
    this.starRating,
    this.background,
    this.relationship,
    this.personality,
    this.plot,
    this.appearance,
    this.identity,
    this.ability,
    this.introduction,
    this.greeting,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'creatorName': creatorName,
      'creatorAvatarUrl': creatorAvatarUrl,
      'chatCount': chatCount,
      'tags': tags.join(','),
      'role': role,
      'scenario': scenario,
      'isPremium': isPremium ? 1 : 0,
      'starRating': starRating,
      'background': background,
      'relationship': relationship,
      'personality': personality,
      'plot': plot,
      'appearance': appearance,
      'identity': identity,
      'ability': ability,
      'introduction': introduction,
      'greeting': greeting,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      description: map['description'],
      creatorName: map['creatorName'],
      creatorAvatarUrl: map['creatorAvatarUrl'],
      chatCount: map['chatCount'],
      tags: (map['tags'] as String).split(','),
      role: map['role'],
      scenario: map['scenario'],
      isPremium: map['isPremium'] == 1,
      starRating: map['starRating'],
      background: map['background'],
      relationship: map['relationship'],
      personality: map['personality'],
      plot: map['plot'],
      appearance: map['appearance'],
      identity: map['identity'],
      ability: map['ability'],
      introduction: map['introduction'],
      greeting: map['greeting'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}