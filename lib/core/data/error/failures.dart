import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure(this.message, [this.code]);

  @override
  List<Object?> get props => [message, code];

  @override
  String toString() => message;
}

/// Server failure
class ServerFailure extends Failure {
  const ServerFailure([String? message, String? code])
    : super(message ?? 'Server error occurred', code);
}

/// Network failure
class NetworkFailure extends Failure {
  const NetworkFailure([String? message])
    : super(
        message ??
            'No internet connection. Please check your connection and try again.',
      );
}

/// Cache failure
class CacheFailure extends Failure {
  const CacheFailure([String? message])
    : super(message ?? 'Failed to load cached data');
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure([String code = 'unauthorized'])
    : super('Authentication failed. Please check your API key.', code);
}

/// Rate limit failure
class RateLimitFailure extends Failure {
  const RateLimitFailure()
    : super('Too many requests. Please try again later.');
}

/// Quota exhausted failure
class QuotaExhaustedFailure extends Failure {
  const QuotaExhaustedFailure()
    : super('API quota exceeded. Please upgrade your plan or try tomorrow.');
}

/// Invalid parameter failure
class InvalidParameterFailure extends Failure {
  const InvalidParameterFailure([String? message, String? code])
    : super(message ?? 'Invalid parameters provided', code);
}

/// Missing parameter failure
class MissingParameterFailure extends Failure {
  const MissingParameterFailure([String? message, String? code])
    : super(message ?? 'Required parameters are missing', code);
}

/// Unknown failure
class UnknownFailure extends Failure {
  const UnknownFailure([String? message])
    : super(message ?? 'An unexpected error occurred');
}
