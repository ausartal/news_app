import '../../data/models/article.dart';

class NewsState {
  const NewsState({
    required this.articles,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.page,
    required this.category,
    required this.query,
    required this.fromCache,
    required this.errorMessage,
    required this.lastUpdated,
  });

  factory NewsState.initial() {
    return const NewsState(
      articles: <Article>[],
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      page: 1,
      category: 'general',
      query: '',
      fromCache: false,
      errorMessage: null,
      lastUpdated: null,
    );
  }

  final List<Article> articles;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String category;
  final String query;
  final bool fromCache;
  final String? errorMessage;
  final DateTime? lastUpdated;

  bool get isInitialLoading => isLoading && articles.isEmpty;
  bool get isEmpty => articles.isEmpty && !isInitialLoading;

  NewsState copyWith({
    List<Article>? articles,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? category,
    String? query,
    bool? fromCache,
    String? errorMessage,
    DateTime? lastUpdated,
  }) {
    return NewsState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      category: category ?? this.category,
      query: query ?? this.query,
      fromCache: fromCache ?? this.fromCache,
      errorMessage: errorMessage,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
