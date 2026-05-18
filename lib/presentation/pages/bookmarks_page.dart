import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/bookmark_controller.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/news_card.dart';
import 'news_detail_page.dart';

class BookmarksPage extends ConsumerWidget {
  const BookmarksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(bookmarkControllerProvider);
    final controller = ref.read(bookmarkControllerProvider.notifier);

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          const SliverAppBar(
            pinned: true,
            title: Text('Bookmarks'),
          ),
          if (state.isLoading)
            const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()))
          else if (state.articles.isEmpty)
            const SliverFillRemaining(
              child: EmptyStateView(
                title: 'No bookmarks yet',
                subtitle: 'Save articles from Home to read them later.',
                icon: Icons.bookmark_border_rounded,
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index.isOdd) {
                      return const SizedBox(height: 16);
                    }

                    final article = state.articles[index ~/ 2];
                    return NewsCard(
                      article: article,
                      isBookmarked: true,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => NewsDetailPage(article: article),
                          ),
                        );
                      },
                      onBookmarkPressed: () async {
                        await controller.removeBookmark(article);
                      },
                    );
                  },
                  childCount: state.articles.isEmpty
                      ? 0
                      : state.articles.length * 2 - 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
