import '../../../../core/base/base_remote_datasource.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/data/api/response_validator.dart';
import '../../../../core/data/error/exceptions.dart';
import '../models/article_model.dart';
import '../models/source_model.dart';
import '../params/everything_params.dart';
import '../params/top_headlines_params.dart';

abstract class HomeRemoteDataSource {
  /// Get top headlines
  Future<ArticlesResponseModel> getTopHeadlines(TopHeadlinesParams params);

  /// Get everything/all articles
  Future<ArticlesResponseModel> getEverything(EverythingParams params);

  /// Get sources
  Future<SourcesResponseModel> getSources({
    String? category,
    String? language,
    String? country,
  });
}

class HomeRemoteDataSourceImpl extends BaseRemoteDataSource
    implements HomeRemoteDataSource {
  HomeRemoteDataSourceImpl(super.dio);

  @override
  Future<ArticlesResponseModel> getTopHeadlines(TopHeadlinesParams params) =>
      execute(() async {
        final response = await dio.get(
          ApiConstants.topHeadlines,
          queryParameters: params.toQueryParameters(),
        );

        return ResponseValidator.validateAndExtract(
          response,
          ArticlesResponseModel.fromJson,
          'Failed to fetch top headlines',
        );
      });

  @override
  Future<ArticlesResponseModel> getEverything(EverythingParams params) =>
      execute(() async {
        // Validate params
        if (!params.isValid) {
          throw InvalidParameterException(
            'At least one of q, qInTitle, sources, or domains is required',
            'parametersMissing',
          );
        }

        final response = await dio.get(
          ApiConstants.everything,
          queryParameters: params.toQueryParameters(),
        );

        return ResponseValidator.validateAndExtract(
          response,
          ArticlesResponseModel.fromJson,
          'Failed to fetch articles',
        );
      });

  @override
  Future<SourcesResponseModel> getSources({
    String? category,
    String? language,
    String? country,
  }) => execute(() async {
    final queryParams = <String, dynamic>{};

    if (category != null) queryParams['category'] = category;
    if (language != null) queryParams['language'] = language;
    if (country != null) queryParams['country'] = country;

    final response = await dio.get(
      ApiConstants.sources,
      queryParameters: queryParams.isNotEmpty ? queryParams : null,
    );

    return ResponseValidator.validateAndExtract(
      response,
      SourcesResponseModel.fromJson,
      'Failed to fetch sources',
    );
  });
}
