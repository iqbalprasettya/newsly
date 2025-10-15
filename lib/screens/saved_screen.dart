import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/saved_articles_provider.dart';
import '../models/article_model.dart';
import '../widgets/news_card.dart';
import '../widgets/modern_app_bar.dart';
import '../utils/error_widget.dart' as custom;
import '../config/app_routes.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SavedArticlesProvider>(
        context,
        listen: false,
      ).loadSavedArticles();
    });
  }

  Future<void> _removeArticle(Article article) async {
    final savedProvider = Provider.of<SavedArticlesProvider>(
      context,
      listen: false,
    );
    await savedProvider.removeArticle(article.url);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed "${article.title}" from saved'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await savedProvider.saveArticle(article);
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Saved Articles',
        actions: [
          Consumer<SavedArticlesProvider>(
            builder: (context, savedProvider, child) {
              if (savedProvider.savedArticles.isNotEmpty) {
                return Container(
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                      width: 1,
                    ),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete_sweep),
                    onPressed: () async {
                      final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Clear All Saved'),
                          content: const Text(
                            'Are you sure you want to remove all saved articles?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text('Clear All'),
                            ),
                          ],
                        ),
                      );

                      if (confirmed == true) {
                        final savedProvider =
                            Provider.of<SavedArticlesProvider>(
                              context,
                              listen: false,
                            );
                        await savedProvider.clearAllArticles();

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('All saved articles cleared'),
                            ),
                          );
                        }
                      }
                    },
                    tooltip: 'Clear All',
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: Consumer<SavedArticlesProvider>(
        builder: (context, savedProvider, child) {
          if (savedProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (savedProvider.savedArticles.isEmpty) {
            return custom.EmptyStateWidget(
              message: 'No saved articles yet',
              icon: Icons.bookmark_border,
            );
          }

          return RefreshIndicator(
            onRefresh: () => savedProvider.loadSavedArticles(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedProvider.savedArticles.length,
              itemBuilder: (context, index) {
                final article = savedProvider.savedArticles[index];
                return Dismissible(
                  key: Key(article.url),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  confirmDismiss: (direction) async {
                    return await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove Article'),
                            content: Text(
                              'Remove "${article.title}" from saved?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Remove'),
                              ),
                            ],
                          ),
                        ) ??
                        false;
                  },
                  onDismissed: (direction) {
                    _removeArticle(article);
                  },
                  child: NewsCard(
                    article: article,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.detail,
                        arguments: article,
                      );
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
