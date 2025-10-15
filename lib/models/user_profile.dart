class UserProfile {
  final String name;
  final String email;
  final String? profileImage;
  final List<String> favoriteCategories;
  final List<String> favoriteSources;
  final String preferredLanguage;
  final String preferredCountry;

  UserProfile({
    required this.name,
    required this.email,
    this.profileImage,
    this.favoriteCategories = const [],
    this.favoriteSources = const [],
    this.preferredLanguage = 'en',
    this.preferredCountry = 'us',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      profileImage: json['profileImage'],
      favoriteCategories: List<String>.from(json['favoriteCategories'] ?? []),
      favoriteSources: List<String>.from(json['favoriteSources'] ?? []),
      preferredLanguage: json['preferredLanguage'] ?? 'en',
      preferredCountry: json['preferredCountry'] ?? 'us',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profileImage': profileImage,
      'favoriteCategories': favoriteCategories,
      'favoriteSources': favoriteSources,
      'preferredLanguage': preferredLanguage,
      'preferredCountry': preferredCountry,
    };
  }

  UserProfile copyWith({
    String? name,
    String? email,
    String? profileImage,
    List<String>? favoriteCategories,
    List<String>? favoriteSources,
    String? preferredLanguage,
    String? preferredCountry,
  }) {
    return UserProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      favoriteCategories: favoriteCategories ?? this.favoriteCategories,
      favoriteSources: favoriteSources ?? this.favoriteSources,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      preferredCountry: preferredCountry ?? this.preferredCountry,
    );
  }
}
