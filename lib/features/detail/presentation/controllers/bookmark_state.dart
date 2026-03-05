import 'package:equatable/equatable.dart';

class BookmarkState extends Equatable {
  final bool isBookmarked;
  final bool isLoading;
  final String? errorMessage;

  const BookmarkState({
    this.isBookmarked = false,
    this.isLoading = false,
    this.errorMessage,
  });

  BookmarkState copyWith({
    bool? isBookmarked,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BookmarkState(
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  BookmarkState clearError() {
    return BookmarkState(
      isBookmarked: isBookmarked,
      isLoading: isLoading,
      errorMessage: null,
    );
  }

  @override
  List<Object?> get props => [isBookmarked, isLoading, errorMessage];
}
