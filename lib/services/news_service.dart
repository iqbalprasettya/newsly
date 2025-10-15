import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article_model.dart';
import '../models/source_model.dart';

class NewsService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = 'API_KEY_HERE';

  // Fetch top headlines
  Future<List<Article>> getTopHeadlines({String country = 'us'}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=$country&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        return articles.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load headlines: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching headlines: $e');
    }
  }

  // Search articles
  Future<List<Article>> searchArticles(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        return articles.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search articles: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching articles: $e');
    }
  }

  // Get articles by category
  Future<List<Article>> getArticlesByCategory(String category) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?category=$category&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        return articles.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load articles by category: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching articles by category: $e');
    }
  }

  // Get news sources
  Future<List<NewsSource>> getNewsSources({
    String? category,
    String? language,
    String? country,
  }) async {
    try {
      String url = '$_baseUrl/top-headlines/sources?apiKey=$_apiKey';

      if (category != null) url += '&category=$category';
      if (language != null) url += '&language=$language';
      if (country != null) url += '&country=$country';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> sources = data['sources'];

        return sources.map((json) => NewsSource.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load sources: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching sources: $e');
    }
  }

  // Get articles by source
  Future<List<Article>> getArticlesBySource(String sourceId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?sources=$sourceId&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> articles = data['articles'];

        return articles.map((json) => Article.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load articles by source: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching articles by source: $e');
    }
  }
}
