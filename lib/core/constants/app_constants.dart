class AppConstants {
  AppConstants._();

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  static const int topHeadlinesPageSize = 5;

  // Debounce
  static const int searchDebounceMilliseconds = 500;

  // Cache Duration
  static const Duration topHeadlinesCacheDuration = Duration(minutes: 30);
  static const Duration sourcesCacheDuration = Duration(hours: 24);
  static const Duration searchCacheDuration = Duration(minutes: 15);

  // Default Values
  static const String defaultCountry = 'us';
  static const String defaultLanguage = 'en';
  static const String defaultSortBy = 'publishedAt';

  // Categories
  static const List<String> categories = [
    'general',
    'business',
    'technology',
    'sports',
    'health',
    'science',
    'entertainment',
  ];

  // Image Placeholder
  static const String placeholderImage =
      'https://via.placeholder.com/400x200?text=No+Image';

  // Source Logo
  static String getSourceLogoUrl(String domain) {
    return 'https://logo.clearbit.com/$domain';
  }

  // App Info
  static const String appName = 'News Insight';
  static const String appVersion = '1.0.0';
}
