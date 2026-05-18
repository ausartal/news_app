import '../../data/models/article.dart';

class NewsPageResult {
  const NewsPageResult({
    required this.articles,
    required this.totalResults,
    required this.fromCache,
    required this.cachedAt,
  });

  final List<Article> articles;
  final int totalResults;
  final bool fromCache;
  final DateTime? cachedAt;
}

abstract class NewsRepository {
  Future<NewsPageResult> fetchTopHeadlines({
    required String category,
    required String query,
    required int page,
    required int pageSize,
  });
}
