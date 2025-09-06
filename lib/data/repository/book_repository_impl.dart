import 'package:book_finder/data/datasource/app_remote_datasource.dart';
import 'package:book_finder/domain/repository/book_repository.dart';

class BookRepositoryImpl extends BookRepository {
  final AppRemoteDataSource remoteDataSource;

  BookRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Result<dynamic>> searchBooks(String title) async {
    try{
      final response = await remoteDataSource.getSearchedBooks(title);
      final List<dynamic> bookJson = response['docs'] ?? [];
      return Result.success(bookJson);
    } catch(e) {
      return Result.failure(e.toString());
    }
  }
}