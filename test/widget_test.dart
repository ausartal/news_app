import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:news_app/app.dart';
import 'package:news_app/data/models/article.dart';
import 'package:news_app/data/repositories/bookmarks_repository_provider.dart';
import 'package:news_app/data/repositories/news_repository_provider.dart';
import 'package:news_app/domain/repositories/bookmarks_repository.dart';
import 'package:news_app/domain/repositories/news_repository.dart';

class _FakeNewsRepository implements NewsRepository {
  @override
  Future<NewsPageResult> fetchTopHeadlines({
    required String category,
    required String query,
    required int page,
    required int pageSize,
  }) async {
    final article = Article(
      title: 'Modern Flutter News',
      description: 'A clean test article.',
      content: 'Content',
      author: 'Copilot',
      url: 'https://example.com',
      urlToImage: 'https://picsum.photos/800/600',
      publishedAt: DateTime(2026, 4, 9),
      sourceName: 'Test Source',
      category: category,
    );

    return NewsPageResult(
      articles: [article],
      totalResults: 1,
      fromCache: false,
      cachedAt: DateTime(2026, 4, 9),
    );
  }
}

class _FakeBookmarksRepository implements BookmarksRepository {
  @override
  Future<List<Article>> loadBookmarks() async => <Article>[];

  @override
  Future<void> saveBookmarks(List<Article> articles) async {}
}

void main() {
  testWidgets('renders News App Modern shell', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          newsRepositoryProvider.overrideWithValue(_FakeNewsRepository()),
          bookmarksRepositoryProvider.overrideWithValue(
            _FakeBookmarksRepository(),
          ),
        ],
        child: const NewsApp(),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.text('News App Modern'), findsWidgets);
    expect(find.text('Bookmark'), findsWidgets);
  });
}
