import '../../../../core/base/base_paginated_cubit.dart';
import '../../../../core/data/error/failures.dart';
import '../../data/models/article_model.dart';
import '../../data/params/everything_params.dart';
import '../../data/repos/home_repository.dart';

class EverythingCubit extends BasePaginatedCubit<ArticleModel> {
  final HomeRepository _repository;
  EverythingParams? _currentParams;

  EverythingCubit(this._repository);

  Future<void> fetchArticles({
    String? query,
    String? sourceId,
    String? language,
    String sortBy = 'publishedAt',
  }) async {
    final params = _buildParams(query, sourceId, language, sortBy);
    await _fetchWithParams(params);
  }

  EverythingParams _buildParams(
    String? query,
    String? sourceId,
    String? language,
    String sortBy,
  ) {
    if (sourceId != null) {
      return EverythingParams.bySource(
        sourceId: sourceId,
        language: language ?? 'en',
      );
    } else if (query != null && query.isNotEmpty) {
      return EverythingParams.search(
        query: query,
        language: language ?? 'en',
        sortBy: sortBy,
      );
    } else {
      return EverythingParams.defaultFeed(language: language ?? 'en');
    }
  }

  Future<void> _fetchWithParams(EverythingParams params) async {
    emitLoading();
    _currentParams = params;

    final result = await _repository.getEverything(params);
    _emitFetchResult(result, params);
  }

  void _emitFetchResult(
    ({Failure? failure, ArticlesResponseModel? data}) result,
    EverythingParams params,
  ) {
    if (result.failure != null) {
      emitError(result.failure!);
    } else if (result.data != null) {
      final articles = result.data!.validArticles;
      if (articles.isEmpty) {
        emitEmpty('No articles found');
      } else {
        final totalResults = result.data!.totalResults;
        final hasMore = totalResults > (params.page * params.pageSize);
        emitPaginatedSuccess(
          items: articles,
          hasReachedMax: !hasMore,
          currentPage: 1,
        );
      }
    }
  }

  /// Fetch more articles (pagination)
  Future<void> fetchMore() async {
    // Emit loading more state
    emitPaginatedSuccess(
      items: items,
      hasReachedMax: hasReachedMax,
      currentPage: currentPage,
      isLoadingMore: true,
    );

    final nextPage = currentPage + 1;
    final params = _currentParams!.copyWith(page: nextPage);

    final result = await _repository.getEverything(params);

    if (result.failure != null) {
      emitPaginatedSuccess(
        items: items,
        hasReachedMax: hasReachedMax,
        currentPage: currentPage,
        isLoadingMore: false,
      );
      emitError(result.failure!);
    } else if (result.data != null) {
      final newArticles = result.data!.validArticles;
      final totalResults = result.data!.totalResults;
      final hasMore = totalResults > (nextPage * params.pageSize);

      final allArticles = List<ArticleModel>.from(items)..addAll(newArticles);
      _currentParams = params;
      emitPaginatedSuccess(
        items: allArticles,
        hasReachedMax: !hasMore || newArticles.isEmpty,
        currentPage: nextPage,
      );
    }
  }

  /// Refresh articles
  Future<void> refresh() async {
    if (_currentParams != null) {
      final params = _currentParams!.copyWith(page: 1);
      await _fetchWithParams(params);
    } else {
      // Fetch default feed if no params
      await fetchArticles();
    }
  }

  /// Filter by source
  Future<void> filterBySource(String sourceId, {String? language}) async {
    await fetchArticles(sourceId: sourceId, language: language);
  }

  /// Clear filters and fetch default feed
  Future<void> clearFilters({String? language}) async {
    await fetchArticles(language: language);
  }
}
