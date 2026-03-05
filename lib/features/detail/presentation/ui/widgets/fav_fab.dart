import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/injection_container.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../../../home/data/models/article_model.dart';
import '../../controllers/bookmark_cubit.dart';
import '../../controllers/bookmark_state.dart';

class FavFab extends StatelessWidget {
  final ArticleModel article;

  const FavFab({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => getIt<BookmarkCubit>()..checkBookmarkStatus(article.url),
      child: BlocConsumer<BookmarkCubit, BookmarkState>(
        listener: (context, state) {
          // Show error message if any
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
            context.read<BookmarkCubit>().clearError();
          }
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: state.isLoading
                ? null
                : () => _toggleBookmark(context, state),
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: state.isLoading
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                : Icon(
                    state.isBookmarked ? Icons.favorite : Icons.favorite_border,
                    color: state.isBookmarked
                        ? (isDarkMode
                            ? AppColors.pinkAccentDark
                            : AppColors.pinkAccentLight)
                        : Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
          );
        },
      ),
    );
  }

  void _toggleBookmark(BuildContext context, BookmarkState state) {
    context.read<BookmarkCubit>().toggleBookmark(article);

    final message = state.isBookmarked
        ? 'Article removed from favourites'
        : 'Article added to favourites';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
