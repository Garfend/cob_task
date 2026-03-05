import 'package:equatable/equatable.dart';

/// Parameters for top headlines endpoint
class TopHeadlinesParams extends Equatable {
  final String? country;
  final String? category;
  final String? sources;
  final String? q;
  final int pageSize;
  final int page;

  const TopHeadlinesParams({
    this.country,
    this.category,
    this.sources,
    this.q,
    this.pageSize = 20,
    this.page = 1,
  });

  /// Convert to query parameters map
  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (country != null) params['country'] = country;
    if (category != null) params['category'] = category;
    if (sources != null) params['sources'] = sources;
    if (q != null && q!.isNotEmpty) params['q'] = q;
    params['pageSize'] = pageSize.toString();
    params['page'] = page.toString();

    return params;
  }

  /// Create default params for home screen
  factory TopHeadlinesParams.defaultHome({String country = 'us'}) {
    return TopHeadlinesParams(country: country, pageSize: 5, page: 1);
  }

  /// Create params for category filter
  factory TopHeadlinesParams.category({
    required String category,
    String country = 'us',
  }) {
    return TopHeadlinesParams(
      country: country,
      category: category,
      pageSize: 20,
      page: 1,
    );
  }

  /// Copy with
  TopHeadlinesParams copyWith({
    String? country,
    String? category,
    String? sources,
    String? q,
    int? pageSize,
    int? page,
  }) {
    return TopHeadlinesParams(
      country: country ?? this.country,
      category: category ?? this.category,
      sources: sources ?? this.sources,
      q: q ?? this.q,
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [country, category, sources, q, pageSize, page];
}
