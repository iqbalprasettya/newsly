import 'package:hive_flutter/hive_flutter.dart';
import '../models/article_model.dart';
import '../models/user_profile.dart';
import 'profile_generator.dart';

class HiveService {
  static const String _articlesBoxName = 'saved_articles';
  static const String _profileBoxName = 'user_profile';
  static const String _settingsBoxName = 'app_settings';

  static Box<Article>? _articlesBox;
  static Box<UserProfile>? _profileBox;
  static Box<dynamic>? _settingsBox;

  // Initialize Hive
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ArticleAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserProfileAdapter());
    }

    // Open boxes
    _articlesBox = await Hive.openBox<Article>(_articlesBoxName);
    _profileBox = await Hive.openBox<UserProfile>(_profileBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  // Article operations
  static Future<void> saveArticle(Article article) async {
    await _articlesBox?.put(article.url, article);
  }

  static Future<void> removeArticle(String articleUrl) async {
    await _articlesBox?.delete(articleUrl);
  }

  static List<Article> getSavedArticles() {
    return _articlesBox?.values.toList() ?? [];
  }

  static bool isArticleSaved(String articleUrl) {
    return _articlesBox?.containsKey(articleUrl) ?? false;
  }

  // Profile operations
  static Future<void> saveUserProfile(UserProfile profile) async {
    await _profileBox?.put('profile', profile);
  }

  static UserProfile? getUserProfile() {
    return _profileBox?.get('profile');
  }

  static Future<UserProfile> getOrCreateUserProfile() async {
    final existingProfile = getUserProfile();

    if (existingProfile != null) {
      return existingProfile;
    }

    // Check if this is first install
    final isFirstInstall =
        _settingsBox?.get('is_first_install', defaultValue: true) ?? true;

    UserProfile newProfile;
    if (isFirstInstall) {
      // Auto-generate random profile for new user (only once)
      newProfile = ProfileGenerator.generateRandomProfile();
      await _settingsBox?.put('is_first_install', false);
    } else {
      // Create default profile
      newProfile = ProfileGenerator.generateDefaultProfile();
    }

    await saveUserProfile(newProfile);
    return newProfile;
  }

  // Settings operations
  static Future<void> clearAllData() async {
    await _articlesBox?.clear();
    await _profileBox?.clear();
    await _settingsBox?.clear();
  }

  static Future<void> resetToFirstInstall() async {
    await _settingsBox?.put('is_first_install', true);
    await _profileBox?.clear();
  }

  // Close boxes
  static Future<void> close() async {
    await _articlesBox?.close();
    await _profileBox?.close();
    await _settingsBox?.close();
  }
}

// Hive Adapters
class ArticleAdapter extends TypeAdapter<Article> {
  @override
  final int typeId = 0;

  @override
  Article read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Article(
      title: fields[0] as String,
      description: fields[1] as String,
      urlToImage: fields[2] as String,
      publishedAt: fields[3] as String,
      content: fields[4] as String,
      url: fields[5] as String,
      source: fields[6] as String,
      author: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Article obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.urlToImage)
      ..writeByte(3)
      ..write(obj.publishedAt)
      ..writeByte(4)
      ..write(obj.content)
      ..writeByte(5)
      ..write(obj.url)
      ..writeByte(6)
      ..write(obj.source)
      ..writeByte(7)
      ..write(obj.author);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArticleAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 1;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: fields[0] as String,
      email: fields[1] as String,
      favoriteCategories: (fields[2] as List).cast<String>(),
      favoriteSources: (fields[3] as List).cast<String>(),
      preferredLanguage: fields[4] as String,
      preferredCountry: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.favoriteCategories)
      ..writeByte(3)
      ..write(obj.favoriteSources)
      ..writeByte(4)
      ..write(obj.preferredLanguage)
      ..writeByte(5)
      ..write(obj.preferredCountry);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;

  @override
  int get hashCode => typeId.hashCode;
}
