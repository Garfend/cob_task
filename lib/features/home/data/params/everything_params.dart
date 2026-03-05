import 'package:equatable/equatable.dart';

class EverythingParams extends Equatable {
  final String? q;
  final String? qInTitle;
  final String? sources;
  final String? domains;
  final String? excludeDomains;
  final String? from;
  final String? to;
  final String? language;
  final String? sortBy;
  final int pageSize;
  final int page;

  const EverythingParams({
    this.q,
    this.qInTitle,
    this.sources,
    this.domains,
    this.excludeDomains,
    this.from,
    this.to,
    this.language,
    this.sortBy = 'publishedAt',
    this.pageSize = 20,
    this.page = 1,
  });

  Map<String, dynamic> toQueryParameters() {
    final params = <String, dynamic>{};

    if (q != null && q!.isNotEmpty) params['q'] = q;
    if (qInTitle != null && qInTitle!.isNotEmpty) params['qInTitle'] = qInTitle;
    if (sources != null && sources!.isNotEmpty) params['sources'] = sources;
    if (domains != null && domains!.isNotEmpty) params['domains'] = domains;
    if (excludeDomains != null && excludeDomains!.isNotEmpty) {
      params['excludeDomains'] = excludeDomains;
    }
    if (from != null) params['from'] = from;
    if (to != null) params['to'] = to;
    if (language != null) params['language'] = language;
    if (sortBy != null) params['sortBy'] = sortBy;
    params['pageSize'] = pageSize.toString();
    params['page'] = page.toString();

    return params;
  }

  bool get isValid {
    return (q != null && q!.isNotEmpty) ||
        (qInTitle != null && qInTitle!.isNotEmpty) ||
        (sources != null && sources!.isNotEmpty) ||
        (domains != null && domains!.isNotEmpty);
  }

  factory EverythingParams.defaultFeed({String language = 'en'}) {
    return EverythingParams(
      q: 'news', // Generic query to get news
      language: language,
      sortBy: 'publishedAt',
      pageSize: 20,
      page: 1,
    );
  }

  factory EverythingParams.bySource({
    required String sourceId,
    String language = 'en',
  }) {
    return EverythingParams(
      sources: sourceId,
      language: language,
      sortBy: 'publishedAt',
      pageSize: 20,
      page: 1,
    );
  }

  factory EverythingParams.search({
    required String query,
    String language = 'en',
    String sortBy = 'relevancy',
  }) {
    return EverythingParams(
      q: query,
      language: language,
      sortBy: sortBy,
      pageSize: 20,
      page: 1,
    );
  }

  EverythingParams copyWith({
    String? q,
    String? qInTitle,
    String? sources,
    String? domains,
    String? excludeDomains,
    String? from,
    String? to,
    String? language,
    String? sortBy,
    int? pageSize,
    int? page,
  }) {
    return EverythingParams(
      q: q ?? this.q,
      qInTitle: qInTitle ?? this.qInTitle,
      sources: sources ?? this.sources,
      domains: domains ?? this.domains,
      excludeDomains: excludeDomains ?? this.excludeDomains,
      from: from ?? this.from,
      to: to ?? this.to,
      language: language ?? this.language,
      sortBy: sortBy ?? this.sortBy,
      pageSize: pageSize ?? this.pageSize,
      page: page ?? this.page,
    );
  }

  @override
  List<Object?> get props => [
    q,
    qInTitle,
    sources,
    domains,
    excludeDomains,
    from,
    to,
    language,
    sortBy,
    pageSize,
    page,
  ];
}
