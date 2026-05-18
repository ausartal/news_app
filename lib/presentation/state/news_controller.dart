import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../core/utils/debouncer.dart';
import '../../data/models/article.dart';
import '../../data/repositories/news_repository_provider.dart';
import '../../domain/repositories/news_repository.dart';
import 'news_state.dart';

final newsControllerProvider =
    StateNotifierProvider<NewsController, NewsState>((ref) {
  final repository = ref.watch(newsRepositoryProvider);
  return NewsController(repository);
});

class NewsController extends StateNotifier<NewsState> {
  NewsController(this._repository) : super(NewsState.initial());

  final NewsRepository _repository;
  final Debouncer _debouncer = Debouncer(milliseconds: 450);

  Future<void> loadInitial() => _load(reset: true);

  Future<void> refresh() => _load(reset: true);

  Future<void> selectCategory(String category) async {
    if (state.category == category) {
      return;
    }

    state = state.copyWith(
        category: category, page: 1, hasMore: true, errorMessage: null);
    await _load(reset: true);
  }

  void updateQuery(String query) {
    if (state.query == query) {
      return;
    }

    state = state.copyWith(
        query: query, page: 1, hasMore: true, errorMessage: null);
    _debouncer(() {
      unawaited(_load(reset: true));
    });
  }

  Future<void> loadMore() async {
    if (!state.hasMore ||
        state.isLoading ||
        state.isLoadingMore ||
        state.articles.isEmpty) {
      return;
    }

    final nextPage = state.page + 1;
    state = state.copyWith(isLoadingMore: true, errorMessage: null);

    try {
      final result = await _repository.fetchTopHeadlines(
        category: state.category,
        query: state.query,
        page: nextPage,
        pageSize: AppConstants.pageSize,
      );

      final combined = <String, Article>{
        for (final article in state.articles) article.uniqueKey: article,
      };
      for (final article in result.articles) {
        combined[article.uniqueKey] = article;
      }

      final merged = combined.values.toList(growable: false);
      state = state.copyWith(
        articles: merged,
        isLoading: false,
        isLoadingMore: false,
        hasMore: merged.length < result.totalResults,
        page: nextPage,
        fromCache: result.fromCache,
        lastUpdated: result.cachedAt ?? DateTime.now(),
      );
    } catch (error) {
      state = state.copyWith(
          isLoadingMore: false, errorMessage: _friendlyMessage(error));
    }
  }

  Future<void> _load({required bool reset}) async {
    if (state.isLoadingMore) {
      return;
    }

    final shouldShowInitialLoading = reset && state.articles.isEmpty;
    state = state.copyWith(
      isLoading: shouldShowInitialLoading,
      errorMessage: null,
      isLoadingMore: false,
      page: reset ? 1 : state.page,
      hasMore: true,
      fromCache: false,
    );

    try {
      final result = await _repository.fetchTopHeadlines(
        category: state.category,
        query: state.query,
        page: 1,
        pageSize: AppConstants.pageSize,
      );

      state = state.copyWith(
        articles: result.articles,
        isLoading: false,
        isLoadingMore: false,
        hasMore: result.articles.length < result.totalResults,
        page: 1,
        fromCache: result.fromCache,
        lastUpdated: result.cachedAt ?? DateTime.now(),
      );
    } catch (error) {
      final message = _friendlyMessage(error);
      if (state.articles.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: message,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          errorMessage: message,
        );
      }
    }
  }

  String _friendlyMessage(Object error) {
    if (error is ApiKeyMissingException) {
      return error.message;
    }
    if (error is NoInternetException) {
      return 'No internet connection. Showing cached data when available.';
    }
    if (error is CacheNotAvailableException) {
      return error.message;
    }
    if (error is NewsApiException) {
      return error.message;
    }
    return 'Something went wrong while loading news.';
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }
}
