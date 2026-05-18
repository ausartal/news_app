import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/news_repository.dart';

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  throw UnimplementedError(
      'newsRepositoryProvider must be overridden in the app bootstrap.');
});
