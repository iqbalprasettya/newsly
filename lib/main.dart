import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/app_theme.dart';
import 'config/app_routes.dart';
import 'providers/news_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/saved_articles_provider.dart';
import 'services/news_service.dart';
import 'services/hive_service.dart';
import 'models/article_model.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NewsProvider()),
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        ChangeNotifierProvider(create: (context) => SavedArticlesProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          // Load theme preference on startup
          WidgetsBinding.instance.addPostFrameCallback((_) {
            themeProvider.loadThemePreference();
          });

          return MaterialApp(
            title: 'Newsly - News App',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            onGenerateRoute: AppRoutes.generateRoute,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

// Test screen untuk memverifikasi API berfungsi
class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final NewsService _newsService = NewsService();
  List<Article> _articles = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _testAPI();
  }

  Future<void> _testAPI() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final articles = await _newsService.getTopHeadlines();
      setState(() {
        _articles = articles;
        _isLoading = false;
      });

      // Print ke console untuk verifikasi
      print('✅ API Test Berhasil!');
      print('📰 Jumlah artikel: ${articles.length}');
      if (articles.isNotEmpty) {
        print('📄 Artikel pertama: ${articles.first.title}');
        print('🔗 URL: ${articles.first.url}');
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      print('❌ API Test Gagal: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newsly - API Test'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '🧪 API Test Results',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 8),
                    if (_isLoading)
                      const Row(
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(width: 16),
                          Text('Testing API connection...'),
                        ],
                      )
                    else if (_error != null)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '❌ Error:',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(_error!),
                        ],
                      )
                    else
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '✅ Success!',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('📰 Found ${_articles.length} articles'),
                          if (_articles.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            const Text('📄 Sample articles:'),
                            ..._articles
                                .take(3)
                                .map(
                                  (article) => Padding(
                                    padding: const EdgeInsets.only(
                                      left: 16,
                                      top: 4,
                                    ),
                                    child: Text('• ${article.title}'),
                                  ),
                                ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: _testAPI,
                child: const Text('🔄 Test API Again'),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '📋 Next Steps:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. ✅ Setup project structure'),
            const Text('2. ✅ Create Article model'),
            const Text('3. ✅ Implement NewsService'),
            const Text('4. ✅ Create NewsProvider'),
            const Text('5. ✅ Test API integration'),
            const Text('6. 🔄 Create UI screens'),
            const Text('7. 🔄 Implement navigation'),
          ],
        ),
      ),
    );
  }
}
