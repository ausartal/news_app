class Article {
  const Article({
    required this.title,
    required this.description,
    required this.content,
    required this.author,
    required this.url,
    required this.urlToImage,
    required this.publishedAt,
    required this.sourceName,
    required this.category,
  });

  final String title;
  final String? description;
  final String? content;
  final String? author;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? sourceName;
  final String? category;

  String get uniqueKey {
    final source = sourceName ?? 'source';
    final date = publishedAt?.millisecondsSinceEpoch.toString() ?? 'unknown';
    final link = url ?? title;
    return '$source-$link-$date';
  }

  String get heroTag => 'article-image-$uniqueKey';

  factory Article.fromJson(Map<String, dynamic> json, {String? category}) {
    return Article(
      title: (json['title'] ?? '') as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.tryParse((json['publishedAt'] ?? '') as String),
      sourceName: (json['source'] as Map<String, dynamic>?)?['name'] as String?,
      category: category,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'content': content,
      'author': author,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt?.toIso8601String(),
      'sourceName': sourceName,
      'category': category,
    };
  }

  factory Article.fromStoredJson(Map<String, dynamic> json) {
    return Article(
      title: (json['title'] ?? '') as String,
      description: json['description'] as String?,
      content: json['content'] as String?,
      author: json['author'] as String?,
      url: json['url'] as String?,
      urlToImage: json['urlToImage'] as String?,
      publishedAt: DateTime.tryParse((json['publishedAt'] ?? '') as String),
      sourceName: json['sourceName'] as String?,
      category: json['category'] as String?,
    );
  }
}
