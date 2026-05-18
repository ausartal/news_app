import '../../data/models/article.dart';

abstract class BookmarksRepository {
  Future<List<Article>> loadBookmarks();
  Future<void> saveBookmarks(List<Article> articles);
}
