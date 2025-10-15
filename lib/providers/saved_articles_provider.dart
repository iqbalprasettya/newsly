import 'package:flutter/material.dart';
import '../models/article_model.dart';
import '../services/storage_wrapper.dart';

class SavedArticlesProvider with ChangeNotifier {
  List<Article> _savedArticles = [];
  bool _isLoading = false;

  List<Article> get savedArticles => _savedArticles;
  bool get isLoading => _isLoading;

  // Load saved articles
  Future<void> loadSavedArticles() async {
    _isLoading = true;
    notifyListeners();

    try {
      _savedArticles = await StorageWrapper.getSavedArticles();
    } catch (e) {
      print('Error loading saved articles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save article
  Future<void> saveArticle(Article article) async {
    try {
      await StorageWrapper.saveArticle(article);
      await loadSavedArticles(); // Refresh the list
    } catch (e) {
      print('Error saving article: $e');
    }
  }

  // Remove article
  Future<void> removeArticle(String articleUrl) async {
    try {
      await StorageWrapper.removeArticle(articleUrl);
      await loadSavedArticles(); // Refresh the list
    } catch (e) {
      print('Error removing article: $e');
    }
  }

  // Check if article is saved
  Future<bool> isArticleSaved(String articleUrl) async {
    try {
      return await StorageWrapper.isArticleSaved(articleUrl);
    } catch (e) {
      print('Error checking if article is saved: $e');
      return false;
    }
  }

  // Clear all saved articles
  Future<void> clearAllArticles() async {
    try {
      await StorageWrapper.clearAllData();
      await loadSavedArticles(); // Refresh the list
    } catch (e) {
      print('Error clearing all articles: $e');
    }
  }
}
