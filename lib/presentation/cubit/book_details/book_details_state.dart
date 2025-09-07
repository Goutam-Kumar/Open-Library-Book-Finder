part of 'book_details_cubit.dart';

sealed class BookDetailsState extends Equatable {
  const BookDetailsState();
}

final class BookDetailsInitial extends BookDetailsState {
  @override
  List<Object> get props => [];
}

final class BookDetailsSaving extends BookDetailsState {
  @override
  List<Object?> get props => [];
}

final class BookDetailsSaved extends BookDetailsState {
  @override
  List<Object?> get props => [];
}

final class BookDetailsError extends BookDetailsState {
  final String error;
  const BookDetailsError({required this.error});

  @override
  List<Object?> get props => [error];
}

final class BookDetailsCaptured extends BookDetailsState {
  final Map<String, dynamic>? book;
  const BookDetailsCaptured({required this.book});

  @override
  List<Object?> get props => [book];
}
