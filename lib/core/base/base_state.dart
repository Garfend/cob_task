import 'package:equatable/equatable.dart';
import '../data/error/failures.dart';
sealed class BaseState<T> extends Equatable {
  const BaseState();

  @override
  List<Object?> get props => [];
}

/// Initial state - nothing has happened yet
class InitialState<T> extends BaseState<T> {
  const InitialState();
}

/// Loading state - data is being fetched
class LoadingState<T> extends BaseState<T> {
  const LoadingState();
}

/// Success state - data fetched successfully
class SuccessState<T> extends BaseState<T> {
  final T data;

  const SuccessState(this.data);

  @override
  List<Object?> get props => [data];
}

/// Paginated success state - for infinite scroll lists
class PaginatedSuccessState<T> extends BaseState<List<T>> {
  final List<T> items;
  final bool hasReachedMax;
  final int currentPage;
  final bool isLoadingMore;

  const PaginatedSuccessState({
    required this.items,
    required this.hasReachedMax,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [items, hasReachedMax, currentPage, isLoadingMore];

  PaginatedSuccessState<T> copyWith({
    List<T>? items,
    bool? hasReachedMax,
    int? currentPage,
    bool? isLoadingMore,
  }) {
    return PaginatedSuccessState<T>(
      items: items ?? this.items,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

/// Error state - an error occurred
class ErrorState<T> extends BaseState<T> {
  final Failure failure;

  const ErrorState(this.failure);

  @override
  List<Object?> get props => [failure];
}

/// Empty state - data fetched but list is empty
class EmptyState<T> extends BaseState<T> {
  final String message;

  const EmptyState([this.message = 'No data available']);

  @override
  List<Object?> get props => [message];
}
