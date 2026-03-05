import '../../../../core/base/base_repository.dart';
import '../datasource/home_remote_datasource.dart';
import '../models/article_model.dart';
import '../models/source_model.dart';
import '../params/everything_params.dart';
import '../params/top_headlines_params.dart';

/// Abstract class defining home repository contract
abstract class HomeRepository {
  /// Get top headlines
  Future<Result<ArticlesResponseModel>> getTopHeadlines(
    TopHeadlinesParams params,
  );

  /// Get everything/all articles
  Future<Result<ArticlesResponseModel>> getEverything(EverythingParams params);

  /// Get sources
  Future<Result<SourcesResponseModel>> getSources({
    String? category,
    String? language,
    String? country,
  });
}

/// Implementation of home repository
class HomeRepositoryImpl extends BaseRepository implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<ArticlesResponseModel>> getTopHeadlines(
    TopHeadlinesParams params,
  ) async {
    return execute(() => _remoteDataSource.getTopHeadlines(params));
  }

  @override
  Future<Result<ArticlesResponseModel>> getEverything(
    EverythingParams params,
  ) async {
    return execute(() => _remoteDataSource.getEverything(params));
  }

  @override
  Future<Result<SourcesResponseModel>> getSources({
    String? category,
    String? language,
    String? country,
  }) async {
    return execute(
      () => _remoteDataSource.getSources(
        category: category,
        language: language,
        country: country,
      ),
    );
  }
}
