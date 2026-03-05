import 'package:flutter_bloc/flutter_bloc.dart';
import 'base_state.dart';

abstract class BasePaginatedCubit<T> extends Cubit<BaseState<List<T>>> {
  BasePaginatedCubit() : super(const InitialState());

  /// Emit loading state
  void emitLoading() {
    emit(const LoadingState());
  }

  /// Emit success state with pagination info
  void emitPaginatedSuccess({
    required List<T> items,
    required bool hasReachedMax,
    required int currentPage,
    bool isLoadingMore = false,
  }) {
    emit(PaginatedSuccessState(
      items: items,
      hasReachedMax: hasReachedMax,
      currentPage: currentPage,
      isLoadingMore: isLoadingMore,
    ));
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
  bool get isLoading => state is LoadingState<List<T>>;

  /// Check if current state is paginated success
  bool get isPaginatedSuccess => state is PaginatedSuccessState<T>;

  /// Check if current state is error
  bool get isError => state is ErrorState<List<T>>;

  /// Get paginated data
  PaginatedSuccessState<T>? get paginatedData {
    if (state is PaginatedSuccessState<T>) {
      return state as PaginatedSuccessState<T>;
    }
    return null;
  }

  /// Get current items
  List<T> get items {
    if (state is PaginatedSuccessState<T>) {
      return (state as PaginatedSuccessState<T>).items;
    }
    return [];
  }

  /// Get current page
  int get currentPage {
    if (state is PaginatedSuccessState<T>) {
      return (state as PaginatedSuccessState<T>).currentPage;
    }
    return 1;
  }

  /// Check if loading more
  bool get isLoadingMore {
    if (state is PaginatedSuccessState<T>) {
      return (state as PaginatedSuccessState<T>).isLoadingMore;
    }
    return false;
  }

  /// Check if has reached max
  bool get hasReachedMax {
    if (state is PaginatedSuccessState<T>) {
      return (state as PaginatedSuccessState<T>).hasReachedMax;
    }
    return false;
  }
}
