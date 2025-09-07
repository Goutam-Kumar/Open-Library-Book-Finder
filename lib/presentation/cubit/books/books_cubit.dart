import 'package:book_finder/domain/repository/book_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'books_state.dart';

class BooksCubit extends Cubit<BooksState> {
  final BookRepository booksRepository;
  List<dynamic> _allBooks = [];
  int _currentPage = 1;
  bool _hasMore = true;

  BooksCubit({required this.booksRepository}): super(BooksInitial());

  Future<void> onSearchBooks({
    required String title,
    int offset = 10,
    int page = 1,
  }) async {
    if (page == 1) {
      _allBooks.clear();
      _hasMore = true;
      _currentPage = 1;
      emit(BooksLoading());
    }

    final result = await booksRepository.searchBooks(title, offset, page);

    if (result.isSuccess) {
      if (page > 1) {
        _allBooks.addAll(result.data['docs']);
      } else {
        _allBooks = List.from(result.data['docs']);
      }

      _hasMore = result.data['num_found'] > _allBooks.length;
      _currentPage = page;

      emit(BooksLoaded(books: List.from(_allBooks)));
    } else {
      emit(BooksFailure(error: result.error!));
    }
  }

  void resetInitial() {
    _allBooks.clear();
    _currentPage = 1;
    _hasMore = true;
    emit(BooksInitial());
  }

  // Helpers
  bool get hasMore => _hasMore;
  int get currentPage => _currentPage;
}
