import 'package:book_finder/data/datasource/app_remote_datasource.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class AppRemoteDataSourceImpl extends AppRemoteDataSource {
  static final Dio _dio = Dio();
  static const String baseUrl = 'https://openlibrary.org';

  static void initialize() {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {'Content-Type': 'application/json'},
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint('Request: ${options.method} ${options.path}');
          handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('Response: ${response.statusCode}');
          handler.next(response);
        },
        onError: (error, handler) {
          debugPrint('Error: ${error.message}');
          handler.next(error);
        },
      ),
    );
  }


  @override
  Future<Map<String, dynamic>> getSearchedBooks(String title) async {
    try {
      final response = await _dio.get(
        '/search.json',
        queryParameters: {
          'title': title
        },
      );
      return response.data;
    } on DioException catch(e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      default:
        return 'Network error occurred';
    }
  }
}