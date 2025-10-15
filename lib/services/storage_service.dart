import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/article_model.dart';
import '../models/user_profile.dart';
import 'profile_generator.dart';

class StorageService {
  static const String _savedArticlesKey = 'saved_articles';
  static const String _userProfileKey = 'user_profile';
  static const String _isFirstInstallKey = 'is_first_install';

  // Save article
  static Future<void> saveArticle(Article article) async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = await getSavedArticles();

    // Check if article already exists
    final exists = savedArticles.any((saved) => saved.url == article.url);
    if (!exists) {
      savedArticles.add(article);
      final articlesJson = savedArticles.map((a) => a.toJson()).toList();
      await prefs.setString(_savedArticlesKey, json.encode(articlesJson));
    }
  }

  // Remove article
  static Future<void> removeArticle(String articleUrl) async {
    final prefs = await SharedPreferences.getInstance();
    final savedArticles = await getSavedArticles();

    savedArticles.removeWhere((article) => article.url == articleUrl);
    final articlesJson = savedArticles.map((a) => a.toJson()).toList();
    await prefs.setString(_savedArticlesKey, json.encode(articlesJson));
  }

  // Get saved articles
  static Future<List<Article>> getSavedArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final articlesJson = prefs.getString(_savedArticlesKey);

    if (articlesJson == null) return [];

    final List<dynamic> articlesList = json.decode(articlesJson);
    return articlesList.map((json) => Article.fromJson(json)).toList();
  }

  // Check if article is saved
  static Future<bool> isArticleSaved(String articleUrl) async {
    final savedArticles = await getSavedArticles();
    return savedArticles.any((article) => article.url == articleUrl);
  }

  // Save user profile
  static Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userProfileKey, json.encode(profile.toJson()));
  }

  // Get user profile (auto-generate only on first install)
  static Future<UserProfile> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);

    if (profileJson == null) {
      // Check if this is first install
      final isFirstInstall = prefs.getBool(_isFirstInstallKey) ?? true;

      if (isFirstInstall) {
        // Auto-generate random profile for new user (only once)
        final newProfile = ProfileGenerator.generateRandomProfile();
        await saveUserProfile(newProfile);
        await prefs.setBool(
          _isFirstInstallKey,
          false,
        ); // Mark as not first install
        return newProfile;
      } else {
        // If not first install but no profile, create default
        final defaultProfile = ProfileGenerator.generateDefaultProfile();
        await saveUserProfile(defaultProfile);
        return defaultProfile;
      }
    }

    return UserProfile.fromJson(json.decode(profileJson));
  }

  // Check if profile exists (without auto-generating)
  static Future<UserProfile?> getUserProfileIfExists() async {
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_userProfileKey);

    if (profileJson == null) return null;

    return UserProfile.fromJson(json.decode(profileJson));
  }

  // Clear all data
  static Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_savedArticlesKey);
    await prefs.remove(_userProfileKey);
    await prefs.remove(_isFirstInstallKey);
  }

  // Reset to first install state (for testing)
  static Future<void> resetToFirstInstall() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isFirstInstallKey, true);
    await prefs.remove(_userProfileKey);
  }
}
