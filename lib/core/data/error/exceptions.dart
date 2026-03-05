abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => message;
}

/// Server-side exceptions
class ServerException extends AppException {
  ServerException([String? message, String? code])
    : super(message ?? 'Server error occurred', code);
}

/// Network/connectivity exceptions
class NetworkException extends AppException {
  NetworkException([String? message])
    : super(message ?? 'No internet connection');
}

/// Cache exceptions
class CacheException extends AppException {
  CacheException([String? message]) : super(message ?? 'Cache error occurred');
}

/// Authentication exceptions
class AuthException extends AppException {
  AuthException([String code = 'unauthorized'])
    : super('Authentication failed', code);
}

/// Rate limit exception
class RateLimitException extends AppException {
  RateLimitException([String? message])
    : super(message ?? 'API rate limit exceeded. Please try again later.');
}

/// Quota exhausted exception
class QuotaExhaustedException extends AppException {
  QuotaExhaustedException([String? message])
    : super(message ?? 'API quota exhausted. Please upgrade your plan.');
}

/// Invalid parameter exception
class InvalidParameterException extends AppException {
  InvalidParameterException([String? message, String? code])
    : super(message ?? 'Invalid parameter provided', code);
}

/// Missing parameter exception
class MissingParameterException extends AppException {
  MissingParameterException([String? message, String? code])
    : super(message ?? 'Required parameter missing', code);
}
