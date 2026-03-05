import 'package:equatable/equatable.dart';

class SourceModel extends Equatable {
  final String? id;
  final String name;
  final String? description;
  final String? url;
  final String? category;
  final String? language;
  final String? country;

  const SourceModel({
    this.id,
    required this.name,
    this.description,
    this.url,
    this.category,
    this.language,
    this.country,
  });

  factory SourceModel.fromJson(Map<String, dynamic> json) {
    return SourceModel(
      id: json['id'] as String?,
      name: json['name'] as String? ?? 'Unknown Source',
      description: json['description'] as String?,
      url: json['url'] as String?,
      category: json['category'] as String?,
      language: json['language'] as String?,
      country: json['country'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'url': url,
      'category': category,
      'language': language,
      'country': country,
    };
  }

  SourceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? url,
    String? category,
    String? language,
    String? country,
  }) {
    return SourceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      url: url ?? this.url,
      category: category ?? this.category,
      language: language ?? this.language,
      country: country ?? this.country,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    url,
    category,
    language,
    country,
  ];

  @override
  String toString() {
    return 'SourceModel(id: $id, name: $name, category: $category)';
  }
}

class SourcesResponseModel extends Equatable {
  final String status;
  final List<SourceModel> sources;

  const SourcesResponseModel({required this.status, required this.sources});

  factory SourcesResponseModel.fromJson(Map<String, dynamic> json) {
    return SourcesResponseModel(
      status: json['status'] as String? ?? 'ok',
      sources:
          (json['sources'] as List<dynamic>?)
              ?.map((e) => SourceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'sources': sources.map((e) => e.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [status, sources];
}
