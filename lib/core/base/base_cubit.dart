import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';

abstract class BaseCubit<T> extends Cubit<BaseState<T>> {
  BaseCubit() : super(const InitialState());

  /// Emit loading state
  void emitLoading() {
    emit(const LoadingState());
  }

  /// Emit success state
  void emitSuccess(T data) {
    emit(SuccessState(data));
  }

  /// Emit error state
  void emitError(failure) {
    emit(ErrorState(failure));
  }

  /// Emit empty state
  void emitEmpty([String message = 'No data available']) {
    emit(EmptyState(message));
  }

  /// Check if current state is loading
  bool get isLoading => state is LoadingState<T>;

  /// Check if current state is success
  bool get isSuccess => state is SuccessState<T>;

  /// Check if current state is error
  bool get isError => state is ErrorState<T>;

  /// Get data from success state
  T? get data {
    if (state is SuccessState<T>) {
      return (state as SuccessState<T>).data;
    }
    return null;
  }
}
