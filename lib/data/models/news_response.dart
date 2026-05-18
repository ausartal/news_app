import 'article.dart';

class NewsApiResponse {
  const NewsApiResponse({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  final String status;
  final int totalResults;
  final List<Article> articles;

  factory NewsApiResponse.fromJson(
    Map<String, dynamic> json, {
    String? category,
  }) {
    final articles = (json['articles'] as List<dynamic>? ?? <dynamic>[])
        .map((item) =>
            Article.fromJson(item as Map<String, dynamic>, category: category))
        .toList();

    return NewsApiResponse(
      status: (json['status'] ?? 'error') as String,
      totalResults: (json['totalResults'] ?? articles.length) as int,
      articles: articles,
    );
  }
}
