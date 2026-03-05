import 'package:dio/dio.dart';
import '../data/error/exceptions.dart';

abstract class BaseRemoteDataSource {
  final Dio dio;

  BaseRemoteDataSource(this.dio);

  /// Execute API call with automatic error handling
  Future<T> execute<T>(Future<T> Function() apiCall) async {
    try {
      return await apiCall();
    } on DioException catch (e) {
      if (e.error is AppException) {
        rethrow;
      }
      throw NetworkException();
    } catch (e) {
      if (e is AppException) {
        rethrow;
      }
      throw ServerException(e.toString());
    }
  }
}
