import 'package:book_finder/data/repository/book_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'mocks.mocks.dart';

void main() {
  late MockAppRemoteDataSource mockRemoteDataSource;
  late MockAppOfflineDataSource mockOfflineDataSource;
  late BookRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockAppRemoteDataSource();
    mockOfflineDataSource = MockAppOfflineDataSource();
    repository = BookRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      offlineDataSource: mockOfflineDataSource,
    );
  });
  
  group('BookRepositoryImpl - searchBooks', () {

    const String title = 'android';
    const int offset = 0;
    const int page = 1;
    final Map<String, dynamic> mockResponse = {
      'docs': [
        {'title': 'Android Book 1', 'author_name': ['Author1']},
        {'title': 'Android Book 2', 'author_name': ['Author2']},
      ],
      'numFound': 2,
    };

    test('should return success result when remote data source returns data', () async {
      when(mockRemoteDataSource.getSearchedBooks(title, offset, page))
          .thenAnswer((_) async => mockResponse);

      final result = await repository.searchBooks(title, offset, page);

      expect(result.isSuccess, true);
      expect(result.data, equals(mockResponse));
      verify(mockRemoteDataSource.getSearchedBooks(title, offset, page)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockOfflineDataSource);
    });

    test('should return failure result when remote data source throws exception', () async {
      const String errorMessage = 'Network connection failed';
      when(mockRemoteDataSource.getSearchedBooks(title, offset, page))
          .thenThrow(Exception(errorMessage));

      final result = await repository.searchBooks(title, offset, page);

      expect(result.isSuccess, false);
      expect(result.error, contains(errorMessage));
      verify(mockRemoteDataSource.getSearchedBooks(title, offset, page)).called(1);
      verifyNoMoreInteractions(mockRemoteDataSource);
      verifyZeroInteractions(mockOfflineDataSource);
    });

    test('should return failure result when remote data source throws string error', () async {
      const String errorMessage = 'API Error';
      when(mockRemoteDataSource.getSearchedBooks(title, offset, page))
          .thenThrow(errorMessage);

      final result = await repository.searchBooks(title, offset, page);

      expect(result.isSuccess, false);
      expect(result.error, equals(errorMessage));
      verify(mockRemoteDataSource.getSearchedBooks(title, offset, page)).called(1);
    });

  });

  group('BookRepositoryImpl - addBook', () {
    final Map<String, dynamic> bookData = {
      'title': 'Android Mock Book',
      'authors': 'Mock Author',
      'cover_i': 12345,
      'first_publish_year': 2025,
    };

    test('should return success result with book ID when offline data source adds book successfully', () async {
      const int expectedBookId = 1;
      when(mockOfflineDataSource.addBook(bookData))
          .thenAnswer((_) async => expectedBookId);

      final result = await repository.addBook(bookData);

      expect(result.isSuccess, true);
      expect(result.data, equals(expectedBookId));
      verify(mockOfflineDataSource.addBook(bookData)).called(1);
      verifyNoMoreInteractions(mockOfflineDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return failure result when offline data source throws database exception', () async {
      const String errorMessage = 'Database Error';
      when(mockOfflineDataSource.addBook(bookData))
          .thenThrow(Exception(errorMessage));

      final result = await repository.addBook(bookData);

      expect(result.isSuccess, false);
      expect(result.error, contains(errorMessage));
      verify(mockOfflineDataSource.addBook(bookData)).called(1);
      verifyNoMoreInteractions(mockOfflineDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should handle different types of exceptions from offline data source', () async {
      when(mockOfflineDataSource.addBook(bookData))
          .thenThrow('Database Error');

      final result = await repository.addBook(bookData);

      expect(result.isSuccess, false);
      expect(result.error, equals('Database Error'));
    });

  });

  group('BookRepositoryImpl - getBookById', () {
    const int bookCoverId = 12345;
    final Map<String, dynamic> expectedBookData = {
      'id': 1,
      'title': 'Android Mock Book',
      'authors': 'Test Author',
      'cover_i': bookCoverId,
    };

    test('should return success result with book data when offline data source returns book', () async {
      when(mockOfflineDataSource.getBookById(bookCoverId))
          .thenAnswer((_) async => expectedBookData);

      final result = await repository.getBookById(bookCoverId);

      expect(result.isSuccess, true);
      expect(result.data, equals(expectedBookData));
      verify(mockOfflineDataSource.getBookById(bookCoverId)).called(1);
      verifyNoMoreInteractions(mockOfflineDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should return success result with null when book is not found', () async {
      when(mockOfflineDataSource.getBookById(bookCoverId))
          .thenAnswer((_) async => null);

      final result = await repository.getBookById(bookCoverId);

      expect(result.isSuccess, true);
      expect(result.data, isNull);
      verify(mockOfflineDataSource.getBookById(bookCoverId)).called(1);
    });

    test('should return failure result when offline data source throws exception', () async {
      const String errorMessage = 'Database query failed';
      when(mockOfflineDataSource.getBookById(bookCoverId))
          .thenThrow(Exception(errorMessage));

      final result = await repository.getBookById(bookCoverId);

      expect(result.isSuccess, false);
      expect(result.error, contains(errorMessage));
      verify(mockOfflineDataSource.getBookById(bookCoverId)).called(1);
      verifyNoMoreInteractions(mockOfflineDataSource);
      verifyZeroInteractions(mockRemoteDataSource);
    });

    test('should handle different book cover IDs', () async {
      const int differentBookCoverId = 67890;
      final Map<String, dynamic> differentBookData = {
        'id': 2,
        'title': 'Mock Android Book',
        'cover_i': differentBookCoverId,
      };
      when(mockOfflineDataSource.getBookById(differentBookCoverId))
          .thenAnswer((_) async => differentBookData);

      final result = await repository.getBookById(differentBookCoverId);

      expect(result.isSuccess, true);
      expect(result.data, equals(differentBookData));
      verify(mockOfflineDataSource.getBookById(differentBookCoverId)).called(1);
    });

  });
  
}