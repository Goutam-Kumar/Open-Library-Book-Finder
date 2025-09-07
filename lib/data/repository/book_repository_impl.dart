import 'package:book_finder/data/datasource/app_remote_datasource.dart';
import 'package:book_finder/domain/repository/book_repository.dart';

class BookRepositoryImpl extends BookRepository {
  final AppRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<dynamic>> searchBooks(
      String title,
      int offset,
      int page ) async {
    try{
      final response = await remoteDataSource.getSearchedBooks(title, offset, page);
      final dynamic bookJson = response;
      return Result.success(bookJson);
    } catch(e) {
      return Result.failure(e.toString());
    }
  }
}