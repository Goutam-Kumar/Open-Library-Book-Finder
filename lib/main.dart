import 'package:book_finder/config/router/app_routers.dart';
import 'package:book_finder/presentation/cubit/books/books_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/single_child_widget.dart';

import 'config/color/palette.dart';
import 'config/service_locator/app_service_locator.dart' as di;
import 'locale/app_locale.dart';

Future<void> main() async {

  await di.serviceLocator();

  runApp(
      MultiBlocProvider(
          providers: [
            ..._createBlocProviders(),
          ],
          child: const MyApp())
  );
}

List<SingleChildWidget> _createBlocProviders() {
  return [
    BlocProvider(create: (context) => di.sl<BooksCubit>()),
  ];
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(
      designSize: Size(429, 926),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: AppLocale.appName,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Palette.primaryBlue,
              brightness: Brightness.light,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Palette.primaryBlue,
              foregroundColor: Colors.white,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Palette.primaryBlue,
                statusBarIconBrightness: Brightness.light,
                statusBarBrightness: Brightness.dark,
              ),
            ),
            scaffoldBackgroundColor: Colors.white,
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              },
            ),
            textSelectionTheme: TextSelectionThemeData(
              cursorColor: Palette.primaryBlue.shade900,
            ),
          ),
          routerConfig: goRouter,
        );
      },
    );
  }
}
