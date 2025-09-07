import 'package:book_finder/domain/repository/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'book_details_state.dart';

class BookDetailsCubit extends Cubit<BookDetailsState> {
  final BookRepository booksRepository;

  BookDetailsCubit({
    required this.booksRepository
  }) : super(BookDetailsInitial());


  Future<void> addBook(Map<String, dynamic> book) async {
    final result = await booksRepository.addBook(book);

    if (result.isSuccess) {
      emit(BookDetailsSaved());
    } else {
      emit(BookDetailsError(error: result.error!));
    }
  }

  Future<void> getBookById(int bookCoverId) async {
    final result = await booksRepository.getBookById(bookCoverId);

    if(result.isSuccess) {
      emit(BookDetailsCaptured(book: result.data));
    } else {
      emit(BookDetailsError(error: result.error!));
    }
  }
}


