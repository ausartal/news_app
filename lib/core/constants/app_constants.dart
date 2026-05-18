class AppConstants {
  static const String appName = 'News App Modern';
  static const String apiBaseUrl = 'https://newsapi.org/v2';
  static const String newsApiKey = 'b8f6bd2c292242228b2983f7e8d89e05';
  static const int pageSize = 10;
  static const String defaultCountry = 'us';

  static const List<String> categories = [
    'general',
    'business',
    'technology',
    'sports',
    'health',
    'science',
    'entertainment',
  ];

  static const Map<String, String> categoryLabels = {
    'general': 'General',
    'business': 'Business',
    'technology': 'Technology',
    'sports': 'Sports',
    'health': 'Health',
    'science': 'Science',
    'entertainment': 'Entertainment',
  };
}
