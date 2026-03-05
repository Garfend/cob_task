import 'package:flutter/material.dart';
import '../../core/base/base_state.dart';
import '../../core/data/error/failures.dart';
import 'error_retry_widget.dart';
import 'loading_widget.dart';

class StateWidgetBuilder {
  StateWidgetBuilder._();

  static Widget buildFromState<T>({
    required BaseState<T> state,
    required Widget Function(T data) onSuccess,
    Widget Function(Failure failure)? onError,
    Widget Function()? onLoading,
    Widget Function(String message)? onEmpty,
    Widget Function()? onInitial,
    required VoidCallback onRetry,
  }) {
    return switch (state) {
      LoadingState() => onLoading?.call() ?? const LoadingWidget(),
      SuccessState(data: final data) => onSuccess(data),
      ErrorState(failure: final failure) =>
        onError?.call(failure) ??
            ErrorRetryWidget(failure: failure, onRetry: onRetry),
      EmptyState(message: final msg) =>
        onEmpty?.call(msg) ?? EmptyStateWidget(message: msg),
      InitialState() => onInitial?.call() ?? const SizedBox.shrink(),
      _ => const SizedBox.shrink(),
    };
  }

  static Widget buildFromPaginatedState<T>({
    required BaseState<List<T>> state,
    required Widget Function(List<T> items, bool isLoadingMore) onSuccess,
    Widget Function(Failure failure)? onError,
    Widget Function()? onLoading,
    Widget Function(String message)? onEmpty,
    required VoidCallback onRetry,
  }) {
    return switch (state) {
      LoadingState() => onLoading?.call() ?? const LoadingWidget(),
      PaginatedSuccessState(
        items: final items,
        isLoadingMore: final isLoadingMore,
      ) =>
        onSuccess(items, isLoadingMore),
      SuccessState(data: final data) => onSuccess(data, false),
      ErrorState(failure: final failure) =>
        onError?.call(failure) ??
            ErrorRetryWidget(failure: failure, onRetry: onRetry),
      EmptyState(message: final msg) =>
        onEmpty?.call(msg) ?? EmptyStateWidget(message: msg),
      _ => const SizedBox.shrink(),
    };
  }
}
