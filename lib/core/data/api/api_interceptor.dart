import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Exception exception;

    if (err.response != null) {
      // Server responded with an error
      final response = err.response!;
      final statusCode = response.statusCode;
      final data = response.data;

      // Try to extract error details from response
      String? errorMessage;
      String? errorCode;

      if (data is Map<String, dynamic>) {
        errorMessage = data['message'] as String?;
        errorCode = data['code'] as String?;
      }

      // Map HTTP status codes to custom exceptions
      switch (statusCode) {
        case 400:
          if (errorCode == 'parameterInvalid') {
            exception = InvalidParameterException(errorMessage, errorCode);
          } else if (errorCode == 'parametersMissing') {
            exception = MissingParameterException(errorMessage, errorCode);
          } else {
            exception = ServerException(errorMessage, errorCode);
          }
          break;

        case 401:
          exception = AuthException(errorCode ?? 'unauthorized');
          break;

        case 429:
          exception = RateLimitException(errorMessage);
          break;

        case 426:
          exception = QuotaExhaustedException(errorMessage);
          break;

        case 500:
        case 502:
        case 503:
        case 504:
          exception = ServerException(errorMessage, errorCode);
          break;

        default:
          exception = ServerException(
            errorMessage ?? 'Unexpected error occurred',
            errorCode,
          );
      }
    } else {
      // No response from server - likely a network issue
      if (err.type == DioExceptionType.connectionTimeout ||
          err.type == DioExceptionType.receiveTimeout ||
          err.type == DioExceptionType.sendTimeout) {
        exception = NetworkException('Connection timeout. Please try again.');
      } else if (err.type == DioExceptionType.connectionError) {
        exception = NetworkException(
          'No internet connection. Please check your network.',
        );
      } else {
        exception = NetworkException();
      }
    }

    // Pass the custom exception to the handler
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: exception,
      ),
    );
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check if the API returned an error status in the body
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      final status = data['status'] as String?;

      if (status == 'error') {
        // API returned an error in the response body
        final message = data['message'] as String?;
        final code = data['code'] as String?;

        handler.reject(
          DioException(
            requestOptions: response.requestOptions,
            response: response,
            type: DioExceptionType.badResponse,
            error: ServerException(message, code),
          ),
        );
        return;
      }
    }

    super.onResponse(response, handler);
  }
}
