import 'package:book_finder/data/datasource/app_offline_datasource.dart';
import 'package:book_finder/data/datasource/app_remote_datasource.dart';
import 'package:book_finder/domain/repository/book_repository.dart';

class BookRepositoryImpl extends BookRepository {
  final AppRemoteDataSource remoteDataSource;
  final AppOfflineDataSource offlineDataSource;


  BookRepositoryImpl({required this.remoteDataSource, required this.offlineDataSource});

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

  @override
  Future<Result<int>> addBook(Map<String, dynamic> book) async {
    try{
      int result = await offlineDataSource.addBook(book);
      return Result.success(result);
    } catch(e) {
      return Result.failure(e.toString());
    }
  }

  @override
  Future<Result<Map<String, dynamic>?>> getBookById(int bookCoverId) async{
    try {
      final result = await offlineDataSource.getBookById(bookCoverId);
      return Result.success(result);
    } catch(e) {
      return Result.failure(e.toString());
    }
  }
}