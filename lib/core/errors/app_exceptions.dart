class ApiKeyMissingException implements Exception {
  ApiKeyMissingException([this.message = 'NewsAPI key is missing.']);

  final String message;

  @override
  String toString() => message;
}

class NoInternetException implements Exception {
  NoInternetException([this.message = 'No internet connection.']);

  final String message;

  @override
  String toString() => message;
}

class CacheNotAvailableException implements Exception {
  CacheNotAvailableException([this.message = 'No cached data is available.']);

  final String message;

  @override
  String toString() => message;
}

class NewsApiException implements Exception {
  NewsApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
