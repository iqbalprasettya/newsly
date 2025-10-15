import 'package:flutter/foundation.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';

class NewsProvider with ChangeNotifier {
  final NewsService _newsService = NewsService();

  List<Article> _articles = [];
  bool _isLoading = false;
  String? _error;
  String _searchQuery = '';

  // Getters
  List<Article> get articles => _articles;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get searchQuery => _searchQuery;

  // Fetch top headlines
  Future<void> fetchTopHeadlines({String country = 'us'}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _newsService.getTopHeadlines(country: country);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _articles = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Search articles
  Future<void> searchArticles(String query) async {
    if (query.isEmpty) {
      await fetchTopHeadlines();
      return;
    }

    _searchQuery = query;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _newsService.searchArticles(query);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _articles = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Get articles by category
  Future<void> getArticlesByCategory(String category) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _articles = await _newsService.getArticlesByCategory(category);
      _error = null;
    } catch (e) {
      _error = e.toString();
      _articles = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  // Clear search
  void clearSearch() {
    _searchQuery = '';
    fetchTopHeadlines();
  }

  // Refresh articles
  Future<void> refreshArticles() async {
    if (_searchQuery.isNotEmpty) {
      await searchArticles(_searchQuery);
    } else {
      await fetchTopHeadlines();
    }
  }
}
