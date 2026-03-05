import '../../../../core/base/base_repository.dart';
import '../../../home/data/models/article_model.dart';
import '../datasource/search_remote_datasource.dart';
import '../params/search_params.dart';

abstract class SearchRepository {
  /// Search articles
  Future<Result<ArticlesResponseModel>> searchArticles(SearchParams params);
}

class SearchRepositoryImpl extends BaseRepository implements SearchRepository {
  final SearchRemoteDataSource _remoteDataSource;

  SearchRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ArticlesResponseModel>> searchArticles(
    SearchParams params,
  ) async {
    return execute(() => _remoteDataSource.searchArticles(params));
  }
}
