import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/base_state.dart';
import '../../../../../core/di/injection_container.dart';
import '../../../../../core/widgets/error_retry_widget.dart';
import '../../../../../core/widgets/shimmer_loading.dart';
import '../../../../home/data/models/article_model.dart';
import '../../controllers/favorites_cubit.dart';
import '../widgets/dismissible_artical_card.dart';
import '../widgets/empty_favorites_widget.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<FavoritesCubit>()..loadFavorites(),
      child: const _FavoritesPageView(),
    );
  }
}

class _FavoritesPageView extends StatelessWidget {
  const _FavoritesPageView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favourite Articles'),
        actions: [

          // Clear all button
          BlocBuilder<FavoritesCubit, BaseState<List<ArticleModel>>>(
            builder: (context, state) {
              if (state is SuccessState<List<ArticleModel>> &&
                  state.data.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.delete_sweep_outlined),
                  onPressed: () => _showClearAllDialog(context),
                  tooltip: 'Clear all',
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<FavoritesCubit>().refresh();
        },
        child: BlocBuilder<FavoritesCubit, BaseState<List<ArticleModel>>>(
          builder: (context, state) {
            return switch (state) {
              LoadingState() => _buildLoadingState(),
              SuccessState(data: final articles) => _buildSuccessState(
                context,
                articles,
              ),
              EmptyState(message: final message) => EmptyFavoritesWidget(
                message: message,
              ),
              ErrorState(failure: final failure) => ErrorRetryWidget(
                failure: failure,
                onRetry: () => context.read<FavoritesCubit>().loadFavorites(),
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => const ArticleCardShimmer(),
    );
  }

  Widget _buildSuccessState(BuildContext context, List<ArticleModel> articles) {
    return ListView.builder(
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return DismissibleArticleCard(
          article: article,
          onDismissed: () {
            context.read<FavoritesCubit>().removeArticle(article.url);
            _showUndoSnackbar(context, article);
          },
        );
      },
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear All Favorites'),
        content: const Text(
          'Are you sure you want to remove all favourite articles? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              context.read<FavoritesCubit>().clearAll();
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  void _showUndoSnackbar(BuildContext context, ArticleModel article) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Article removed from favorites'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
