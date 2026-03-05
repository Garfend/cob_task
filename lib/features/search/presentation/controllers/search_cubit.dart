import 'dart:async';

import '../../../../core/base/base_paginated_cubit.dart';
import '../../../../core/base/base_state.dart';
import '../../../../core/data/error/failures.dart';
import '../../../../core/utils/debouncer.dart';
import '../../../home/data/models/article_model.dart';
import '../../data/params/search_params.dart';
import '../../data/repos/search_repository.dart';

class SearchCubit extends BasePaginatedCubit<ArticleModel> {
  final SearchRepository _repository;
  final Debouncer _debouncer;
  String _currentQuery = '';
  SearchParams? _currentParams;

  SearchCubit(this._repository)
      : _debouncer = Debouncer(milliseconds: 500);

  String get currentQuery => _currentQuery;

  bool get hasSearchResults => items.isNotEmpty;

  bool get isInitial => _currentQuery.isEmpty && items.isEmpty && !isLoading;

  void search(String query, {String? language}) {
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }

    _debouncer.run(() {
      _performSearch(query, language: language);
    });
  }

  Future<void> _performSearch(String query, {String? language}) async {
    final params = _buildSearchParams(query, language);
    await _executeSearch(query, params);
  }

  SearchParams _buildSearchParams(String query, String? language) {
    return SearchParams.defaultSearch(query: query, language: language ?? 'en');
  }

  Future<void> _executeSearch(String query, SearchParams params) async {
    _currentQuery = query;
    _currentParams = params;
    emitLoading();

    final result = await _repository.searchArticles(params);
    _emitSearchResult(result, params);
  }

  void _emitSearchResult(
    ({Failure? failure, ArticlesResponseModel? data}) result,
    SearchParams params,
  ) {
    if (result.failure != null) {
      emitError(result.failure!);
    } else {
      final articles = result.data!.validArticles;
      if (articles.isEmpty) {
        emitEmpty('No results found for "$_currentQuery"');
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

  Future<void> loadMore() async {
    if (isLoadingMore || hasReachedMax || _currentParams == null) {
      return;
    }

    emitPaginatedSuccess(
      items: items,
      hasReachedMax: hasReachedMax,
      currentPage: currentPage,
      isLoadingMore: true,
    );

    final nextPage = currentPage + 1;
    final params = _currentParams!.copyWith(page: nextPage);

    final result = await _repository.searchArticles(params);

    if (result.failure != null) {
      emitPaginatedSuccess(
        items: items,
        hasReachedMax: hasReachedMax,
        currentPage: currentPage,
        isLoadingMore: false,
      );
      emitError(result.failure!);
    } else {
      final newArticles = result.data!.validArticles;
      final allArticles = List.of(items)..addAll(newArticles);

      final totalResults = result.data!.totalResults;
      final hasMore = totalResults > (nextPage * params.pageSize);

      _currentParams = params;
      emitPaginatedSuccess(
        items: allArticles,
        hasReachedMax: !hasMore || newArticles.isEmpty,
        currentPage: nextPage,
      );
    }
  }

  void clearSearch() {
    _currentQuery = '';
    _currentParams = null;
    emit(const InitialState());
  }

  Future<void> refresh() async {
    if (_currentQuery.isNotEmpty && _currentParams != null) {
      await _performSearch(
        _currentQuery,
        language: _currentParams!.language,
      );
    }
  }

  @override
  Future<void> close() {
    _debouncer.dispose();
    return super.close();
  }
}
