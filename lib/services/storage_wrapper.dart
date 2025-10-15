import '../models/article_model.dart';
import '../models/user_profile.dart';
import 'storage_service.dart';
import 'hive_service.dart';

class StorageWrapper {
  // Use Hive by default, fallback to SharedPreferences
  static bool _useHive = true;

  // Article operations
  static Future<void> saveArticle(Article article) async {
    if (_useHive) {
      try {
        await HiveService.saveArticle(article);
      } catch (e) {
        // Fallback to SharedPreferences
        _useHive = false;
        await StorageService.saveArticle(article);
      }
    } else {
      await StorageService.saveArticle(article);
    }
  }

  static Future<void> removeArticle(String articleUrl) async {
    if (_useHive) {
      try {
        await HiveService.removeArticle(articleUrl);
      } catch (e) {
        _useHive = false;
        await StorageService.removeArticle(articleUrl);
      }
    } else {
      await StorageService.removeArticle(articleUrl);
    }
  }

  static Future<List<Article>> getSavedArticles() async {
    if (_useHive) {
      try {
        return HiveService.getSavedArticles();
      } catch (e) {
        _useHive = false;
        return await StorageService.getSavedArticles();
      }
    } else {
      return await StorageService.getSavedArticles();
    }
  }

  static Future<bool> isArticleSaved(String articleUrl) async {
    if (_useHive) {
      try {
        return HiveService.isArticleSaved(articleUrl);
      } catch (e) {
        _useHive = false;
        return await StorageService.isArticleSaved(articleUrl);
      }
    } else {
      return await StorageService.isArticleSaved(articleUrl);
    }
  }

  // Profile operations
  static Future<void> saveUserProfile(UserProfile profile) async {
    if (_useHive) {
      try {
        await HiveService.saveUserProfile(profile);
      } catch (e) {
        _useHive = false;
        await StorageService.saveUserProfile(profile);
      }
    } else {
      await StorageService.saveUserProfile(profile);
    }
  }

  static Future<UserProfile> getUserProfile() async {
    if (_useHive) {
      try {
        return await HiveService.getOrCreateUserProfile();
      } catch (e) {
        _useHive = false;
        return await StorageService.getUserProfile();
      }
    } else {
      return await StorageService.getUserProfile();
    }
  }

  static Future<UserProfile?> getUserProfileIfExists() async {
    if (_useHive) {
      try {
        return HiveService.getUserProfile();
      } catch (e) {
        _useHive = false;
        return await StorageService.getUserProfileIfExists();
      }
    } else {
      return await StorageService.getUserProfileIfExists();
    }
  }

  // Utility operations
  static Future<void> clearAllData() async {
    if (_useHive) {
      try {
        await HiveService.clearAllData();
      } catch (e) {
        _useHive = false;
        await StorageService.clearAllData();
      }
    } else {
      await StorageService.clearAllData();
    }
  }

  static Future<void> resetToFirstInstall() async {
    if (_useHive) {
      try {
        await HiveService.resetToFirstInstall();
      } catch (e) {
        _useHive = false;
        await StorageService.resetToFirstInstall();
      }
    } else {
      await StorageService.resetToFirstInstall();
    }
  }

  // Get storage type being used
  static String getStorageType() {
    return _useHive ? 'Hive' : 'SharedPreferences';
  }
}
