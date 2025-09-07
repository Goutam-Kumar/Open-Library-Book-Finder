import 'package:book_finder/data/database/database_helper.dart';
import 'package:book_finder/data/datasource/app_offline_datasource.dart';

class AppOfflineDatasourceImpl extends AppOfflineDataSource {
  static final DatabaseHelper _db = DatabaseHelper.instance;

  @override
  Future<int> addBook(Map<String, dynamic> book) async {
    int result = await _db.insertBook({
      'id': book['cover_i'],
      'title': book['title'],
      'authors': book['author_name'] != null
          ? (book['author_name'] as List).join(", ") : ''
    });
    return result;
  }

  @override
  Future<Map<String, dynamic>?> getBookById(int bookCoverId) async {
    Map<String, dynamic>? book = await _db.getBookById(bookCoverId);
    return book;
  }

}