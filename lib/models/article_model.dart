class Article {
  final String title;
  final String description;
  final String urlToImage;
  final String publishedAt;
  final String content;
  final String url;
  final String author;
  final String source;

  Article({
    required this.title,
    required this.description,
    required this.urlToImage,
    required this.publishedAt,
    required this.content,
    required this.url,
    required this.author,
    required this.source,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      urlToImage: json['urlToImage'] ?? '',
      publishedAt: json['publishedAt'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      author: json['author'] ?? '',
      source: json['source'] is String
          ? json['source']
          : json['source']?['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'url': url,
      'author': author,
      'source': source,
    };
  }
}
