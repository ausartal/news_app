import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../models/news_response.dart';

class NewsApiService {
  NewsApiService(this._dio, {String? apiKey})
      : _apiKey = apiKey ??
            const String.fromEnvironment(
              'NEWS_API_KEY',
              defaultValue: AppConstants.newsApiKey,
            );

  final Dio _dio;
  final String _apiKey;

  Future<NewsApiResponse> fetchTopHeadlines({
    required String category,
    required String query,
    required int page,
    required int pageSize,
  }) async {
    if (_apiKey.isEmpty || _apiKey == 'YOUR_NEWSAPI_KEY') {
      throw ApiKeyMissingException(
          'NewsAPI key is missing. Set NEWS_API_KEY via --dart-define.');
    }

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/top-headlines',
        queryParameters: {
          'apiKey': _apiKey,
          'country': AppConstants.defaultCountry,
          if (category.isNotEmpty && category != 'general')
            'category': category,
          if (query.trim().isNotEmpty) 'q': query.trim(),
          'page': page,
          'pageSize': pageSize,
        },
        options: Options(
          headers: const {'Accept': 'application/json'},
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      final data = response.data;
      if (data == null) {
        throw NewsApiException('Invalid response from server.');
      }

      final apiResponse = NewsApiResponse.fromJson(data, category: category);
      if (apiResponse.status != 'ok') {
        throw NewsApiException(
            data['message']?.toString() ?? 'Unexpected API status.');
      }

      return apiResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout ||
          error.type == DioExceptionType.sendTimeout) {
        throw NewsApiException('Request timeout. Please try again.');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw NoInternetException();
      }
      throw NewsApiException(error.message ?? 'Failed to load news.');
    }
  }
}
