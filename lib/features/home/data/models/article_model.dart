import 'package:equatable/equatable.dart';
import 'source_model.dart';

class ArticleModel extends Equatable {
  final SourceModel source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String? content;

  const ArticleModel({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  bool get isValid {
    return title != '[Removed]' && title.isNotEmpty;
  }

  String get displayAuthor {
    if (author != null && author!.isNotEmpty) {
      return author!;
    }
    return source.name;
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: SourceModel.fromJson(
        json['source'] as Map<String, dynamic>? ?? {},
      ),
      author: json['author'] as String?,
      title: json['title'] as String? ?? '[No Title]',
      description: json['description'] as String?,
      url: json['url'] as String? ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt:
          json['publishedAt'] as String? ?? DateTime.now().toIso8601String(),
      content: json['content'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source.toJson(),
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }

  Map<String, dynamic> toDatabase() {
    return {
      'source_id': source.id,
      'source_name': source.name,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'url_to_image': urlToImage,
      'published_at': publishedAt,
      'content': content,
      'bookmarked_at': DateTime.now().toIso8601String(),
    };
  }

  factory ArticleModel.fromDatabase(Map<String, dynamic> map) {
    return ArticleModel(
      source: SourceModel(
        id: map['source_id'] as String?,
        name: map['source_name'] as String? ?? 'Unknown',
      ),
      author: map['author'] as String?,
      title: map['title'] as String? ?? '[No Title]',
      description: map['description'] as String?,
      url: map['url'] as String? ?? '',
      urlToImage: map['url_to_image'] as String?,
      publishedAt:
          map['published_at'] as String? ?? DateTime.now().toIso8601String(),
      content: map['content'] as String?,
    );
  }

  ArticleModel copyWith({
    SourceModel? source,
    String? author,
    String? title,
    String? description,
    String? url,
    String? urlToImage,
    String? publishedAt,
    String? content,
  }) {
    return ArticleModel(
      source: source ?? this.source,
      author: author ?? this.author,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      urlToImage: urlToImage ?? this.urlToImage,
      publishedAt: publishedAt ?? this.publishedAt,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [
    source,
    author,
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
  ];

  @override
  String toString() {
    return 'ArticleModel(title: $title, source: ${source.name}, url: $url)';
  }
}

class ArticlesResponseModel extends Equatable {
  final String status;
  final int totalResults;
  final List<ArticleModel> articles;

  const ArticlesResponseModel({
    required this.status,
    required this.totalResults,
    required this.articles,
  });

  List<ArticleModel> get validArticles {
    return articles.where((article) => article.isValid).toList();
  }

  factory ArticlesResponseModel.fromJson(Map<String, dynamic> json) {
    final articlesList =
        (json['articles'] as List<dynamic>?)
            ?.map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [];

    return ArticlesResponseModel(
      status: json['status'] as String? ?? 'ok',
      totalResults: json['totalResults'] as int? ?? 0,
      articles: articlesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'totalResults': totalResults,
      'articles': articles.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, totalResults, articles];
}
