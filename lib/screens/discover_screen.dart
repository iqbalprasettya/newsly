import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../models/article_model.dart';
import '../services/news_service.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/modern_app_bar.dart';
import '../utils/error_widget.dart' as custom;
import '../config/app_routes.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final NewsService _newsService = NewsService();
  final TextEditingController _searchController = TextEditingController();
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'all';

  final List<String> _categories = [
    'all',
    'business',
    'entertainment',
    'general',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  void initState() {
    super.initState();
    _loadArticlesByCategory(_selectedCategory);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadArticlesByCategory(String category) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      List<Article> articles;
      if (category == 'all') {
        articles = await _newsService.getTopHeadlines();
      } else {
        articles = await _newsService.getArticlesByCategory(category);
      }

      setState(() {
        _articles = articles;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    if (query.isEmpty) {
      _loadArticlesByCategory(_selectedCategory);
      return;
    }

    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.searchArticles(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Discover',
        integrated: true, // Use integrated mode like Home
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search news...',
                hintStyle: TextStyle(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.6),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.6),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          _loadArticlesByCategory(_selectedCategory);
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
              onChanged: _onSearch,
              onSubmitted: _onSearch,
            ),
          ),

          const SizedBox(height: 16),

          // Categories Content
          Expanded(child: _buildCategoriesTab()),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return Column(
      children: [
        // Categories Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Choose a category to explore news',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),

        // Category Chips
        Container(
          height: 50,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            itemBuilder: (context, index) {
              final category = _categories[index];
              final isSelected = _selectedCategory == category;

              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    _loadArticlesByCategory(category);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(
                                context,
                              ).colorScheme.outline.withOpacity(0.2),
                        width: 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                    ),
                    child: Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 20),

        // Articles List
        Expanded(child: _buildArticlesList()),
      ],
    );
  }

  Widget _buildArticlesList() {
    if (_isLoading) {
      return const LoadingList();
    }

    if (_error != null) {
      return custom.ErrorWidget(
        message: _error!,
        onRetry: () => _loadArticlesByCategory(_selectedCategory),
      );
    }

    if (_articles.isEmpty) {
      return custom.EmptyStateWidget(
        message: 'No articles found for $_selectedCategory',
        action: ElevatedButton(
          onPressed: () => _loadArticlesByCategory(_selectedCategory),
          child: const Text('Load Articles'),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _articles.length,
      itemBuilder: (context, index) {
        final article = _articles[index];
        return NewsCard(
          article: article,
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.detail, arguments: article);
          },
        );
      },
    );
  }
}
