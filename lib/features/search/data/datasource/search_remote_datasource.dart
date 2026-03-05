import '../../../../core/base/base_remote_datasource.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/data/api/response_validator.dart';
import '../../../../core/data/error/exceptions.dart';
import '../../../home/data/models/article_model.dart';
import '../params/search_params.dart';

abstract class SearchRemoteDataSource {
  /// Search articles with query
  Future<ArticlesResponseModel> searchArticles(SearchParams params);
}

class SearchRemoteDataSourceImpl extends BaseRemoteDataSource
    implements SearchRemoteDataSource {
  SearchRemoteDataSourceImpl(super.dio);

  @override
  Future<ArticlesResponseModel> searchArticles(SearchParams params) =>
      execute(() async {
        if (!params.isValid) {
          throw InvalidParameterException('Search query cannot be empty');
        }

        final response = await dio.get(
          ApiConstants.everything,
          queryParameters: params.toQueryParameters(),
        );

        return ResponseValidator.validateAndExtract(
          response,
          ArticlesResponseModel.fromJson,
          'Failed to search articles',
        );
      });
}
