import 'package:book_finder/locale/app_locale.dart';
import 'package:book_finder/presentation/cubit/books/books_cubit.dart';
import 'package:book_finder/presentation/widget/book_list_widget.dart';
import 'package:book_finder/presentation/widget/book_shimmer_widget.dart';
import 'package:book_finder/presentation/widget/search_box_with_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}
class _LandingPageState extends State<LandingPage> {
  List<dynamic> booksList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocale.home),
        ),
        body: _buildBooksList(context)
    );
  }

  Widget _buildBooksList(BuildContext context) {
    return Column(
      children: [
        SearchBoxWithAction(
          hintText: "Search Books with Title",
          onSearch: (search) {
            context
                .read<BooksCubit>()
                .onSearchBooks(title: search);
          },
          onClear: () {
            setState(() {
              booksList = [];
              context
                  .read<BooksCubit>()
                  .resetInitial();
            });
          },
        ),

        Expanded(
            child: BlocBuilder<BooksCubit, BooksState>(
                builder: (context, state) {

                  if( state is BooksLoading) {
                    debugPrint("Show Shimmer animation");
                    return ListView.separated(
                      itemCount: 6,
                      separatorBuilder: (context, index) => Divider(color: Colors.grey[200]),
                      itemBuilder: (context, index) => BookShimmerWidget(),
                    );
                  }

                  if( state is BooksLoaded) {
                    booksList = state.books;
                  }

                  if(state is BooksFailure) {
                    debugPrint("Search Books Failed: ${state.error}");
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48.w, color: Colors.grey),
                          SizedBox(height: 16.h),
                          Text('Failed to load books: ${state.error}',
                              style: TextStyle(fontSize: 18.sp)
                          ),
                        ],
                      ),
                    );
                  }

                  if(booksList.isNotEmpty) {
                    // Book list view
                    return ListView.builder(
                      itemCount: booksList.length ,
                      itemBuilder: (context, index) {
                        final book = booksList[index];
                        return BookListWidget(book: book);
                      },
                    );

                  } else {
                    //Empty View
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search, size: 48.w, color: Colors.grey),
                          SizedBox(height: 16.h),
                          Text(
                            'Search for books to get started',
                            style: TextStyle(fontSize: 18.sp),
                          ),
                        ],
                      ),
                    );

                  }
                }
            )
        )
      ],
    );
  }

}


