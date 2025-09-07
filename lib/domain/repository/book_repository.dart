class Result<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  Result.success(this.data): error = null, isSuccess = true;
  Result.failure(this.error): data = null, isSuccess = false;
}

abstract class BookRepository {
  Future<Result<dynamic>> searchBooks(String title, int offset, int page);
  Future<Result<int>> addBook(Map<String, dynamic> book);
  Future<Result<Map<String, dynamic>? >> getBookById(int bookCoverId);
}