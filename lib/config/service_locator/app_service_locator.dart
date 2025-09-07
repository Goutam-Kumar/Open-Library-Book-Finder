import 'package:book_finder/data/datasource/app_offline_datasource.dart';
import 'package:book_finder/data/datasource/app_offline_datasource_impl.dart';
import 'package:book_finder/data/datasource/app_remote_datasource.dart';
import 'package:book_finder/data/datasource/app_remote_datasource_impl.dart';
import 'package:book_finder/data/repository/book_repository_impl.dart';
import 'package:book_finder/domain/repository/book_repository.dart';
import 'package:book_finder/presentation/cubit/book_details/book_details_cubit.dart';
import 'package:book_finder/presentation/cubit/books/books_cubit.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> serviceLocator() async {
  AppRemoteDataSourceImpl.initialize();

  sl.registerLazySingleton<AppRemoteDataSource>(
          () => AppRemoteDataSourceImpl()
  );

  sl.registerLazySingleton<AppOfflineDataSource>(
          () => AppOfflineDatasourceImpl()
  );

  sl.registerLazySingleton<BookRepository>(
          () => BookRepositoryImpl(
          remoteDataSource: sl.call(),
          offlineDataSource: sl.call()
      )
  );

  sl.registerFactory<BooksCubit>(
          () => BooksCubit(booksRepository: sl.call())
  );

  sl.registerFactory<BookDetailsCubit>(
          () => BookDetailsCubit(booksRepository: sl.call())
  );
}
