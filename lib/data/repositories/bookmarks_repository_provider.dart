import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/bookmarks_repository.dart';

final bookmarksRepositoryProvider = Provider<BookmarksRepository>((ref) {
  throw UnimplementedError(
    'bookmarksRepositoryProvider must be overridden in the app bootstrap.',
  );
});
