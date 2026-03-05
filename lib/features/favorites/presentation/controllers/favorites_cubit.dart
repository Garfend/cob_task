import '../../../../core/base/base_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../../home/data/models/article_model.dart';
import '../../data/repos/favorites_repository.dart';

class FavoritesCubit extends BaseCubit<List<ArticleModel>> {
  final FavoritesRepository _repository;

  FavoritesCubit(this._repository);

  Future<void> loadFavorites() async {
    emit(const LoadingState());

    final result = await _repository.getFavorites();

    if (result.failure != null) {
      emit(ErrorState(result.failure!));
    } else {
      final articles = result.data!;
      if (articles.isEmpty) {
        emit(const EmptyState('No favourite articles yet'));
      } else {
        emit(SuccessState(articles));
      }
    }
  }

  Future<void> removeArticle(String url) async {
    if (state is! SuccessState<List<ArticleModel>>) return;

    final currentArticles = (state as SuccessState<List<ArticleModel>>).data;

    // Optimistically update UI
    final updatedArticles = currentArticles.where((a) => a.url != url).toList();

    if (updatedArticles.isEmpty) {
      emit(const EmptyState('No favourite articles yet'));
    } else {
      emit(SuccessState(updatedArticles));
    }

    final result = await _repository.removeFromFavorites(url);

    if (result.failure != null) {
      emit(SuccessState(currentArticles));
      emit(ErrorState(result.failure!));
    }
  }

  Future<void> clearAll() async {
    final result = await _repository.clearAllFavorites();

    if (result.failure != null) {
      emit(ErrorState(result.failure!));
    } else {
      emit(const EmptyState('No favourite articles yet'));
    }
  }

  Future<void> refresh() async {
    await loadFavorites();
  }

  Future<int> getFavoritesCount() async {
    final result = await _repository.getFavoritesCount();
    return result.data ?? 0;
  }
}
