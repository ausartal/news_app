import '../../domain/repositories/bookmarks_repository.dart';
import '../models/article.dart';
import '../services/local_storage_service.dart';

class BookmarksRepositoryImpl implements BookmarksRepository {
  BookmarksRepositoryImpl(this._storageService);

  final LocalStorageService _storageService;

  @override
  Future<List<Article>> loadBookmarks() async =>
      _storageService.loadBookmarks();

  @override
  Future<void> saveBookmarks(List<Article> articles) =>
      _storageService.saveBookmarks(articles);
}
