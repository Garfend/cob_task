import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/base_state.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/error_retry_widget.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../../../home/data/models/article_model.dart';
import '../../../../home/presentation/ui/widgets/article_card.dart';
import '../../controllers/search_cubit.dart';
import '../widgets/search_bar.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SearchCubit>(),
      child: const _SearchPageView(),
    );
  }
}

class _SearchPageView extends StatefulWidget {
  const _SearchPageView();

  @override
  State<_SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<_SearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<SearchCubit>().loadMore();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        children: [
          SearchBarWidget(
            searchController: _searchController,
            onChange: (query) {
              context.read<SearchCubit>().search(query);
              setState(() {});
            },
          ),

          Expanded(
            child: BlocBuilder<SearchCubit, BaseState<List<ArticleModel>>>(
              builder: (context, state) {
                final cubit = context.read<SearchCubit>();

                // Initial state
                if (state is InitialState) {
                  return _buildInitialState();
                }

                // Loading state
                if (state is LoadingState) {
                  return _buildLoadingState();
                }

                // Error state
                if (state is ErrorState<List<ArticleModel>>) {
                  return ErrorRetryWidget(
                    failure: state.failure,
                    onRetry: () => cubit.refresh(),
                  );
                }

                // Empty state
                if (state is EmptyState) {
                  return _buildEmptyState(cubit.currentQuery);
                }

                // Success state with pagination
                if (state is PaginatedSuccessState<ArticleModel>) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: _buildResultsList(state),
                  );
                }

                return _buildInitialState();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Enter keywords to find articles',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const ArticleCardShimmer(),
    );
  }

  Widget _buildEmptyState(String query) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No results found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'No articles found for "$query"\nTry different keywords',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsList(PaginatedSuccessState<ArticleModel> state) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: state.items.length + (state.hasReachedMax ? 0 : 1),
      itemBuilder: (context, index) {
        if (index >= state.items.length) {
          // Load more indicator
          if (!state.hasReachedMax) {
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return const SizedBox.shrink();
        }

        final article = state.items[index];
        return ArticleCard(article: article);
      },
    );
  }
}
