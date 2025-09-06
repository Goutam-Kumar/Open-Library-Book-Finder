part of 'books_cubit.dart';

sealed class BooksState extends Equatable {
  const BooksState();
}

final class BooksInitial extends BooksState {
  @override
  List<Object> get props => [];
}

final class BooksLoading extends BooksState {
  @override
  List<Object?> get props => [];
}

final class BooksLoaded extends BooksState {
  final dynamic books;
  const BooksLoaded({required this.books});

  @override
  List<Object?> get props => [books];
}

final class BooksFailure extends BooksState {
  final String error;
  const BooksFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
