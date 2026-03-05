import 'failures.dart';

class ErrorMessageMapper {
  ErrorMessageMapper._();

  /// Convert failure to user-understandable message
  static String getUserMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() =>
        'No internet connection.\nPlease check your Wi-Fi or mobile data.',
      AuthFailure() => 'Invalid API key.\nPlease contact support.',
      RateLimitFailure() =>
        'Too many requests.\nPlease wait a moment and try again.',
      QuotaExhaustedFailure() =>
        'Daily request limit reached.\nPlease try again tomorrow or upgrade your plan.',
      ServerFailure() =>
        'Server is not responding.\nWe\'re working on it. Please try again later.',
      InvalidParameterFailure() =>
        'Invalid request.\nPlease check your search criteria and try again.',
      MissingParameterFailure() =>
        'Missing information.\nPlease provide all required details.',
      CacheFailure() =>
        'Failed to load saved data.\nPlease check your device storage.',
      UnknownFailure() => 'Something went wrong.\nPlease try again.',
    };
  }

  /// Get debug message with technical details (dev only)
  static String getDebugMessage(Failure failure) {
    if (failure.code != null) {
      return '${failure.message} (Code: ${failure.code})';
    }
    return failure.message;
  }
}
