import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../config/theme/theme_cubit.dart';
import '../../../../../core/base/base_state.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/error_retry_widget.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../../data/models/article_model.dart';
import '../../../data/models/source_model.dart';
import '../../controllers/everything_cubit.dart';
import '../../controllers/sources_cubit.dart';
import '../../controllers/top_headlines_cubit.dart';
import '../widgets/article_card.dart';
import '../widgets/headline_carousel.dart';
import '../widgets/source_circles.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<TopHeadlinesCubit>()..fetchTopHeadlines(),
        ),
        BlocProvider(create: (_) => getIt<SourcesCubit>()..fetchSources()),
        BlocProvider(create: (_) => getIt<EverythingCubit>()..fetchArticles()),
      ],
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatefulWidget {
  const _HomePageView();

  @override
  State<_HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<_HomePageView> {
  String? _selectedSourceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Insight'),
        actions: [
          // Theme Toggle
          IconButton(
            icon: Icon(
              context.watch<ThemeCubit>().state.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            context.read<TopHeadlinesCubit>().refresh(),
            context.read<EverythingCubit>().refresh(),
          ]);
        },
        child: CustomScrollView(
          slivers: [
            // Top Headlines Banner Section
            SliverToBoxAdapter(
              child:
                  BlocBuilder<TopHeadlinesCubit, BaseState<List<ArticleModel>>>(
                    builder: (context, state) {
                      return switch (state) {
                        LoadingState() => const Padding(
                          padding: EdgeInsets.all(16),
                          child: BannerShimmer(),
                        ),
                        SuccessState(data: final articles) => HeadlinesBanner(
                          articles: articles,
                        ),
                        ErrorState() => const SizedBox.shrink(),
                        _ => const SizedBox.shrink(),
                      };
                    },
                  ),
            ),

            // Source Circles Section
            SliverToBoxAdapter(
              child: BlocBuilder<SourcesCubit, BaseState<List<SourceModel>>>(
                builder: (context, state) {
                  return switch (state) {
                    LoadingState() => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        height: 90,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    SuccessState(data: final sources) => Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: SourceCircles(
                        sources: sources,
                        selectedSourceId: _selectedSourceId,
                        onSourceSelected: (sourceId) {
                          setState(() {
                            _selectedSourceId = sourceId;
                          });
                          // Fetch articles filtered by source
                          if (sourceId == null) {
                            context.read<EverythingCubit>().clearFilters();
                          } else {
                            context.read<EverythingCubit>().filterBySource(
                              sourceId,
                            );
                          }
                        },
                      ),
                    ),
                    ErrorState() => const SizedBox.shrink(),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ),


            // Articles Feed
            BlocBuilder<EverythingCubit, BaseState<List<ArticleModel>>>(
              builder: (context, state) {
                return switch (state) {
                  LoadingState() => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => const ArticleCardShimmer(),
                      childCount: 5,
                    ),
                  ),
                  ErrorState(failure: final failure) => SliverFillRemaining(
                    child: ErrorRetryWidget(
                      failure: failure,
                      onRetry: () =>
                          context.read<EverythingCubit>().fetchArticles(),
                    ),
                  ),
                  PaginatedSuccessState<ArticleModel>(
                    :final items,
                    :final hasReachedMax,
                  ) =>
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          if (index >= items.length) {
                            // Load more indicator
                            if (!hasReachedMax) {
                              context.read<EverythingCubit>().fetchMore();
                              return const Padding(
                                padding: EdgeInsets.all(16),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            return const SizedBox.shrink();
                          }

                          final article = items[index];
                          return ArticleCard(article: article);
                        },
                        childCount: items.length + (hasReachedMax ? 0 : 1),
                      ),
                    ),
                  EmptyState(message: final msg) => SliverFillRemaining(
                    child: EmptyStateWidget(
                      message: msg,
                      action: ElevatedButton.icon(
                        onPressed: () =>
                            context.read<EverythingCubit>().fetchArticles(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ),
                  ),
                  _ => SliverFillRemaining(
                    child: EmptyStateWidget(
                      message: 'No news available',
                      action: ElevatedButton.icon(
                        onPressed: () =>
                            context.read<EverythingCubit>().fetchArticles(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Refresh'),
                      ),
                    ),
                  ),
                };
              },
            ),
          ],
        ),
      ),
    );
  }
}
