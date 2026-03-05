import '../data/constants/api_key.dart';

class ApiConstants {
  ApiConstants._();

  // Base URL
  static const String baseUrl = 'https://newsapi.org/v2';

  // API Key - Using the key from api_key.dart
  static final String? apiKey = ApiKey.apiKey;

  // Endpoints
  static const String topHeadlines = '/top-headlines';
  static const String everything = '/everything';
  static const String sources = '/top-headlines/sources';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Headers
  static const String apiKeyHeader = 'X-Api-Key';
  static const String contentType = 'application/json';
}
