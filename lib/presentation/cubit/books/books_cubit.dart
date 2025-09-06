import 'package:bloc/bloc.dart';
import 'package:book_finder/domain/repository/book_repository.dart';
import 'package:equatable/equatable.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final BookRepository booksRepository;

  BooksCubit({required this.booksRepository}): super(BooksInitial());

  Future<void> onSearchBooks({required String title}) async {
    emit(BooksLoading());

    final result = await booksRepository.searchBooks(title);

    if(result.isSuccess) {
      emit(BooksLoaded(books: result.data!));
    } else {
      emit(BooksFailure(error: result.error!));
    }
  }

  void resetInitial() {
    emit(BooksInitial());
  }
}
