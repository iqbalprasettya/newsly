import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/article_model.dart';
import '../services/storage_wrapper.dart';
import '../providers/saved_articles_provider.dart';
import '../widgets/modern_app_bar.dart';

class DetailScreen extends StatefulWidget {
  final Article article;

  const DetailScreen({super.key, required this.article});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  bool _isSaved = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkIfSaved();
  }

  Future<void> _checkIfSaved() async {
    final isSaved = await StorageWrapper.isArticleSaved(widget.article.url);
    setState(() {
      _isSaved = isSaved;
    });
  }

  Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);

      // Try different launch modes
      bool launched = false;

      // First try with external application
      if (await canLaunchUrl(uri)) {
        launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      }

      // If that fails, try with platform default
      if (!launched && await canLaunchUrl(uri)) {
        launched = await launchUrl(uri, mode: LaunchMode.platformDefault);
      }

      // If still fails, try with in-app web view
      if (!launched && await canLaunchUrl(uri)) {
        launched = await launchUrl(uri, mode: LaunchMode.inAppWebView);
      }

      if (!launched) {
        throw Exception('Unable to launch URL');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open article: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Copy URL',
              onPressed: () {
                // Copy URL to clipboard
                Clipboard.setData(ClipboardData(text: url));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('URL copied to clipboard'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        );
      }
    }
  }

  Future<void> _toggleSave() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final savedProvider = Provider.of<SavedArticlesProvider>(
        context,
        listen: false,
      );

      if (_isSaved) {
        await savedProvider.removeArticle(widget.article.url);
        setState(() {
          _isSaved = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Article removed from saved'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        // Ensure user profile exists (auto-generate if needed)
        await StorageWrapper.getUserProfile();

        await savedProvider.saveArticle(widget.article);
        setState(() {
          _isSaved = true;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Article saved successfully'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _formatDate(String dateString) {
    try {
      final DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd, yyyy • HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ModernAppBar(
        title: 'Article Detail',
        showBackButton: true,
        integrated: true, // Use integrated mode like Home
        actions: [
          Container(
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 1,
              ),
            ),
            child: IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_isSaved ? Icons.bookmark : Icons.bookmark_border),
              onPressed: _isLoading ? null : _toggleSave,
              tooltip: _isSaved ? 'Remove from saved' : 'Save article',
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            if (widget.article.urlToImage.isNotEmpty)
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(widget.article.urlToImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.article.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Meta information
                  Row(
                    children: [
                      if (widget.article.source.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.article.source,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (widget.article.publishedAt.isNotEmpty)
                        Text(
                          _formatDate(widget.article.publishedAt),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),

                  if (widget.article.author.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      'By ${widget.article.author}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // Description
                  if (widget.article.description.isNotEmpty) ...[
                    Text(
                      'Summary',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.article.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Content
                  if (widget.article.content.isNotEmpty) ...[
                    Text(
                      'Full Content',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.article.content,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _launchURL(widget.article.url),
                      icon: const Icon(Icons.open_in_browser),
                      label: const Text('Read Full Article'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Additional Info
                  if (widget.article.url.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Source URL',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.article.url,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(color: Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
