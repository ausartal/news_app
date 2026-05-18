import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/bookmarks_repository_provider.dart';
import '../../domain/repositories/bookmarks_repository.dart';
import '../../data/models/article.dart';
import 'bookmark_state.dart';

final bookmarkControllerProvider =
    StateNotifierProvider<BookmarkController, BookmarkState>((ref) {
  final repository = ref.watch(bookmarksRepositoryProvider);
  return BookmarkController(repository);
});

class BookmarkController extends StateNotifier<BookmarkState> {
  BookmarkController(this._repository) : super(BookmarkState.initial()) {
    _loadBookmarks();
  }

  final BookmarksRepository _repository;

  Future<void> _loadBookmarks() async {
    final items = await _repository.loadBookmarks();
    state = state.copyWith(articles: items, isLoading: false);
  }

  bool contains(Article article) {
    return state.articles.any((item) => item.uniqueKey == article.uniqueKey);
  }

  Future<void> toggleBookmark(Article article) async {
    final exists = contains(article);
    final updated = List<Article>.of(state.articles);

    if (exists) {
      updated.removeWhere((item) => item.uniqueKey == article.uniqueKey);
    } else {
      updated.insert(0, article);
    }

    state = state.copyWith(articles: updated);
    await _repository.saveBookmarks(updated);
  }

  Future<void> removeBookmark(Article article) async {
    final updated = List<Article>.of(state.articles)
      ..removeWhere((item) => item.uniqueKey == article.uniqueKey);
    state = state.copyWith(articles: updated);
    await _repository.saveBookmarks(updated);
  }

  Future<void> clearBookmarks() async {
    state = state.copyWith(articles: <Article>[]);
    await _repository.saveBookmarks(<Article>[]);
  }

  Future<void> refresh() => _loadBookmarks();
}
