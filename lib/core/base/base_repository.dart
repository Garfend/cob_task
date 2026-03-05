import '../data/error/exceptions.dart';
import '../data/error/failures.dart';

typedef Result<T> = ({Failure? failure, T? data});

/// Base repository with common error handling
abstract class BaseRepository {
  /// Execute a function and handle errors, returning a Result
  Future<Result<T>> execute<T>(Future<T> Function() function) async {
    try {
      final data = await function();
      return (failure: null, data: data);
    } on ServerException catch (e) {
      return (failure: ServerFailure(e.message, e.code), data: null);
    } on NetworkException catch (e) {
      return (failure: NetworkFailure(e.message), data: null);
    } on CacheException catch (e) {
      return (failure: CacheFailure(e.message), data: null);
    } on AuthException catch (e) {
      return (failure: AuthFailure(e.code ?? 'unauthorized'), data: null);
    } on RateLimitException {
      return (failure: const RateLimitFailure(), data: null);
    } on QuotaExhaustedException {
      return (failure: const QuotaExhaustedFailure(), data: null);
    } on InvalidParameterException catch (e) {
      return (failure: InvalidParameterFailure(e.message, e.code), data: null);
    } on MissingParameterException catch (e) {
      return (failure: MissingParameterFailure(e.message, e.code), data: null);
    } catch (e) {
      return (failure: UnknownFailure(e.toString()), data: null);
    }
  }

  /// Execute a function and handle errors, returning either Failure or T
  /// This throws the failure instead of returning a record
  Future<T> executeOrThrow<T>(Future<T> Function() function) async {
    final result = await execute(function);
    if (result.failure != null) {
      throw result.failure!;
    }
    return result.data as T;
  }
}
