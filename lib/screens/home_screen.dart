import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/news_provider.dart';
import '../config/app_routes.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_loading.dart';
import '../widgets/breaking_news_slider.dart';
import '../widgets/modern_app_bar.dart';
import '../utils/error_widget.dart' as custom;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Data sudah di-fetch di splash screen
  }

  Future<void> _refreshArticles() async {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    await newsProvider.refreshArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Newsly',
        integrated: true, // Use integrated mode (no card)
      ),
      body: Consumer<NewsProvider>(
        builder: (context, newsProvider, child) {
          if (newsProvider.isLoading) {
            return const LoadingList();
          }

          if (newsProvider.error != null) {
            return custom.ErrorWidget(
              message: newsProvider.error!,
              onRetry: _refreshArticles,
            );
          }

          if (newsProvider.articles.isEmpty) {
            return custom.EmptyStateWidget(message: 'No articles found');
          }

          return RefreshIndicator(
            onRefresh: _refreshArticles,
            child: CustomScrollView(
              slivers: [
                // Breaking News Slider
                SliverToBoxAdapter(
                  child: BreakingNewsSlider(
                    articles: newsProvider.articles.take(5).toList(),
                  ),
                ),

                // Recommendations Header
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
                    child: Text(
                      'Recommendations',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // News List
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final article = newsProvider.articles[index + 5];
                    return NewsCard(
                      article: article,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.detail,
                          arguments: article,
                        );
                      },
                    );
                  }, childCount: newsProvider.articles.length - 5),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
