import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../favorites/data/repos/favorites_repository.dart';
import '../../../home/data/models/article_model.dart';
import 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  final FavoritesRepository _repository;

  BookmarkCubit(this._repository) : super(const BookmarkState());

  Future<void> checkBookmarkStatus(String url) async {
    emit(state.copyWith(isLoading: true));

    final result = await _repository.isFavorite(url);

    if (result.failure != null) {
      emit(
        state.copyWith(isLoading: false, errorMessage: result.failure!.message),
      );
    } else {
      emit(
        state.copyWith(isBookmarked: result.data ?? false, isLoading: false),
      );
    }
  }

  Future<void> toggleBookmark(ArticleModel article) async {
    final previousState = state;

    emit(state.copyWith(isBookmarked: !state.isBookmarked, isLoading: true));

    final result = state.isBookmarked
        ? await _repository.addToFavorites(article)
        : await _repository.removeFromFavorites(article.url);

    if (result.failure != null) {
      emit(
        previousState.copyWith(
          isLoading: false,
          errorMessage: result.failure!.message,
        ),
      );
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> addToFavorites(ArticleModel article) async {
    if (state.isBookmarked) return;

    emit(state.copyWith(isLoading: true));

    final result = await _repository.addToFavorites(article);

    if (result.failure != null) {
      emit(
        state.copyWith(isLoading: false, errorMessage: result.failure!.message),
      );
    } else {
      emit(state.copyWith(isBookmarked: true, isLoading: false));
    }
  }

  Future<void> removeFromFavorites(String url) async {
    if (!state.isBookmarked) return;

    emit(state.copyWith(isLoading: true));

    final result = await _repository.removeFromFavorites(url);

    if (result.failure != null) {
      emit(
        state.copyWith(isLoading: false, errorMessage: result.failure!.message),
      );
    } else {
      emit(state.copyWith(isBookmarked: false, isLoading: false));
    }
  }

  void clearError() {
    emit(state.clearError());
  }
}
