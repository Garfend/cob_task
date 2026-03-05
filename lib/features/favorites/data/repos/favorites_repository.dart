import '../../../../core/base/base_repository.dart';
import '../../../home/data/models/article_model.dart';
import '../datasource/favorites_local_datasource.dart';

abstract class FavoritesRepository {
  /// Add article to favorites
  Future<Result<void>> addToFavorites(ArticleModel article);

  /// Remove article from favorites
  Future<Result<void>> removeFromFavorites(String url);

  /// Get all favorite articles
  Future<Result<List<ArticleModel>>> getFavorites();

  /// Check if article is favorited
  Future<Result<bool>> isFavorite(String url);

  /// Clear all favorites
  Future<Result<void>> clearAllFavorites();

  /// Get favorites count
  Future<Result<int>> getFavoritesCount();
}

class FavoritesRepositoryImpl extends BaseRepository
    implements FavoritesRepository {
  final FavoritesLocalDataSource _localDataSource;

  FavoritesRepositoryImpl(this._localDataSource);

  @override
  Future<Result<void>> addToFavorites(ArticleModel article) async {
    return execute(() => _localDataSource.insertArticle(article));
  }

  @override
  Future<Result<void>> removeFromFavorites(String url) async {
    return execute(() => _localDataSource.deleteArticle(url));
  }

  @override
  Future<Result<List<ArticleModel>>> getFavorites() async {
    return execute(() => _localDataSource.getAllFavorites());
  }

  @override
  Future<Result<bool>> isFavorite(String url) async {
    return execute(() => _localDataSource.isFavorite(url));
  }

  @override
  Future<Result<void>> clearAllFavorites() async {
    return execute(() => _localDataSource.clearAll());
  }

  @override
  Future<Result<int>> getFavoritesCount() async {
    return execute(() => _localDataSource.getFavoritesCount());
  }
}
