import 'package:dio/dio.dart';

import '../../core/errors/app_exceptions.dart';
import '../../core/utils/network_checker.dart';
import '../../domain/repositories/news_repository.dart';
import '../models/article.dart';
import '../services/local_storage_service.dart';
import '../services/news_api_service.dart';

class NewsRepositoryImpl implements NewsRepository {
  NewsRepositoryImpl({
    required NewsApiService apiService,
    required LocalStorageService storageService,
    required NetworkChecker networkChecker,
  })  : _apiService = apiService,
        _storageService = storageService,
        _networkChecker = networkChecker;

  final NewsApiService _apiService;
  final LocalStorageService _storageService;
  final NetworkChecker _networkChecker;

  String _cacheKey(
      {required String category, required String query, required int page}) {
    final normalizedQuery =
        query.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '_');
    final normalizedCategory = category.trim().toLowerCase();
    return 'news_cache_${normalizedCategory}_${normalizedQuery}_page_$page';
  }

  @override
  Future<NewsPageResult> fetchTopHeadlines({
    required String category,
    required String query,
    required int page,
    required int pageSize,
  }) async {
    final cacheKey = _cacheKey(category: category, query: query, page: page);
    final hasConnection = await _networkChecker.hasConnection;

    if (!hasConnection) {
      final cached = _storageService.loadCache(cacheKey);
      if (cached != null) {
        return _parseCachedResult(cached);
      }
      throw NoInternetException();
    }

    try {
      final response = await _apiService.fetchTopHeadlines(
        category: category,
        query: query,
        page: page,
        pageSize: pageSize,
      );

      final payload = <String, dynamic>{
        'cachedAt': DateTime.now().toIso8601String(),
        'totalResults': response.totalResults,
        'articles':
            response.articles.map((article) => article.toJson()).toList(),
      };
      await _storageService.saveCache(cacheKey, payload);

      return NewsPageResult(
        articles: response.articles,
        totalResults: response.totalResults,
        fromCache: false,
        cachedAt: DateTime.now(),
      );
    } on ApiKeyMissingException {
      rethrow;
    } on NoInternetException {
      final cached = _storageService.loadCache(cacheKey);
      if (cached != null) {
        return _parseCachedResult(cached);
      }
      rethrow;
    } on NewsApiException {
      final cached = _storageService.loadCache(cacheKey);
      if (cached != null) {
        return _parseCachedResult(cached);
      }
      rethrow;
    } on DioException {
      final cached = _storageService.loadCache(cacheKey);
      if (cached != null) {
        return _parseCachedResult(cached);
      }
      rethrow;
    }
  }

  NewsPageResult _parseCachedResult(Map<String, dynamic> cached) {
    final articles = (cached['articles'] as List<dynamic>? ?? <dynamic>[])
        .map((item) => Article.fromStoredJson(item as Map<String, dynamic>))
        .toList();

    return NewsPageResult(
      articles: articles,
      totalResults: (cached['totalResults'] ?? articles.length) as int,
      fromCache: true,
      cachedAt: DateTime.tryParse(cached['cachedAt']?.toString() ?? ''),
    );
  }
}
