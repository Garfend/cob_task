import 'package:equatable/equatable.dart';

class SearchParams extends Equatable {
  final String query;
  final String? language;
  final String? sortBy;
  final int pageSize;
  final int page;

  const SearchParams({
    required this.query,
    this.language,
    this.sortBy,
    this.pageSize = 20,
    this.page = 1,
  });

  factory SearchParams.defaultSearch({
    required String query,
    String language = 'en',
  }) {
    return SearchParams(
      query: query,
      language: language,
      sortBy: 'publishedAt',
      pageSize: 20,
      page: 1,
    );
  }

  bool get isValid => query.trim().isNotEmpty;

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{
      'q': query,
      'pageSize': pageSize,
      'page': page,
    };

    if (language != null) params['language'] = language;
    if (sortBy != null) params['sortBy'] = sortBy;

    return params;
  }

  SearchParams copyWith({
    String? query,
    String? language,
    String? sortBy,
    int? pageSize,
    int? page,
  }) {
    return SearchParams(
      query: query ?? this.query,
      language: language ?? this.language,
      sortBy: sortBy ?? this.sortBy,
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [query, language, sortBy, pageSize, page];
}
