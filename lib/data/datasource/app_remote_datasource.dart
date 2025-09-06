abstract class AppRemoteDataSource {
  Future<Map<String, dynamic>> getSearchedBooks(String title);
}