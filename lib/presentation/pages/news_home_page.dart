import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/article.dart';
import '../state/bookmark_controller.dart';
import '../state/news_controller.dart';
import '../widgets/category_chips.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/news_card.dart';
import '../widgets/news_shimmer.dart';
import 'news_detail_page.dart';

class NewsHomePage extends ConsumerStatefulWidget {
  const NewsHomePage({super.key});

  @override
  ConsumerState<NewsHomePage> createState() => _NewsHomePageState();
}

class _NewsHomePageState extends ConsumerState<NewsHomePage> {
  late final ScrollController _scrollController;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _searchController = TextEditingController();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.read(newsControllerProvider.notifier).loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) {
      return;
    }

    if (_scrollController.position.extentAfter < 500) {
      ref.read(newsControllerProvider.notifier).loadMore();
    }
  }

  Future<void> _onRefresh() =>
      ref.read(newsControllerProvider.notifier).refresh();

  void _openDetail(Article article) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) =>
            NewsDetailPage(article: article),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final fade =
              CurvedAnimation(parent: animation, curve: Curves.easeOut);
          final slide =
              Tween<Offset>(begin: const Offset(0.04, 0.08), end: Offset.zero)
                  .animate(fade);
          return FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(newsControllerProvider);
    final bookmarkState = ref.watch(bookmarkControllerProvider);
    final bookmarkController = ref.read(bookmarkControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics()),
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            title: const Text(AppConstants.appName),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                onPressed: _onRefresh,
                icon: const Icon(Icons.refresh_rounded),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(72),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: TextField(
                  controller: _searchController,
                  onChanged:
                      ref.read(newsControllerProvider.notifier).updateQuery,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search latest news...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              ref
                                  .read(newsControllerProvider.notifier)
                                  .updateQuery('');
                            },
                            icon: const Icon(Icons.clear_rounded),
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 14)),
          SliverToBoxAdapter(
            child: CategoryChips(
              selectedCategory: state.category,
              onSelected: (category) => ref
                  .read(newsControllerProvider.notifier)
                  .selectCategory(category),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          if (state.fromCache)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.cloud_off_rounded, color: colorScheme.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          state.lastUpdated == null
                              ? 'Showing cached data.'
                              : 'Offline cache • Updated ${DateFormatter.format(state.lastUpdated)}',
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (state.errorMessage != null && state.articles.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _InfoBanner(message: state.errorMessage!),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          if (state.isInitialLoading)
            const SliverFillRemaining(child: NewsShimmer())
          else if (state.errorMessage != null && state.articles.isEmpty)
            SliverFillRemaining(
              child: EmptyStateView(
                title: 'Unable to load news',
                subtitle: state.errorMessage ?? 'Please try again later.',
                icon: (state.errorMessage ?? '')
                        .toLowerCase()
                        .contains('internet')
                    ? Icons.wifi_off_rounded
                    : Icons.error_outline_rounded,
                onRetry: _onRefresh,
                buttonLabel: 'Retry',
              ),
            )
          else if (state.articles.isEmpty)
            SliverFillRemaining(
              child: EmptyStateView(
                title: 'No news found',
                subtitle: 'Try another search or category.',
                icon: Icons.newspaper_rounded,
                onRetry: _onRefresh,
                buttonLabel: 'Reload',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final articleCount = state.articles.length;
                    final hasLoader = state.isLoadingMore;
                    final contentItemCount =
                        articleCount == 0 ? 0 : articleCount * 2 - 1;
                    final totalCount = contentItemCount + (hasLoader ? 1 : 0);

                    if (index >= totalCount) {
                      return null;
                    }

                    if (hasLoader && index == totalCount - 1) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 18),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    if (index.isOdd) {
                      return const SizedBox(height: 16);
                    }

                    final article = state.articles[index ~/ 2];
                    final isBookmarked = bookmarkState.articles
                        .any((item) => item.uniqueKey == article.uniqueKey);

                    return NewsCard(
                      article: article,
                      isBookmarked: isBookmarked,
                      onTap: () => _openDetail(article),
                      onBookmarkPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await bookmarkController.toggleBookmark(article);
                        if (!mounted) {
                          return;
                        }
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text(isBookmarked
                                ? 'Removed from bookmarks'
                                : 'Added to bookmarks'),
                          ),
                        );
                      },
                    );
                  },
                  childCount: state.articles.isEmpty
                      ? 0
                      : state.articles.length * 2 -
                          1 +
                          (state.isLoadingMore ? 1 : 0),
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}
