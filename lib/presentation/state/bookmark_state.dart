import '../../data/models/article.dart';

class BookmarkState {
  const BookmarkState({
    required this.articles,
    required this.isLoading,
  });

  factory BookmarkState.initial() {
    return const BookmarkState(
      articles: <Article>[],
      isLoading: true,
    );
  }

  final List<Article> articles;
  final bool isLoading;

  BookmarkState copyWith({
    List<Article>? articles,
    bool? isLoading,
  }) {
    return BookmarkState(
      articles: articles ?? this.articles,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
