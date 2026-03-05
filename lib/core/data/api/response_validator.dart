import 'package:dio/dio.dart';
import '../error/exceptions.dart';

class ResponseValidator {
  ResponseValidator._();

  /// Validate response and extract data using fromJson
  static T validateAndExtract<T>(
    Response response,
    T Function(Map<String, dynamic>) fromJson,
    String errorMessage,
  ) {
    if (response.statusCode != 200) {
      throw ServerException(errorMessage, response.statusCode.toString());
    }

    if (response.data == null) {
      throw ServerException('Empty response');
    }

    try {
      return fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      throw ServerException('Failed to parse response: $errorMessage');
    }
  }

  /// Validate response status code only
  static void validateStatusCode(Response response, String errorMessage) {
    if (response.statusCode != 200) {
      throw ServerException(errorMessage, response.statusCode.toString());
    }
  }

  /// Check if response data is null
  static void validateData(Response response) {
    if (response.data == null) {
      throw ServerException('Empty response');
    }
  }
}
