abstract class AppOfflineDataSource {
  Future<int> addBook(Map<String, dynamic> book);
  Future<Map<String, dynamic>?> getBookById(int bookCoverId);
}