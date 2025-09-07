import 'dart:math' as math;

import 'package:book_finder/config/color/palette.dart';
import 'package:book_finder/locale/app_locale.dart';
import 'package:book_finder/presentation/cubit/book_details/book_details_cubit.dart';
import 'package:book_finder/presentation/widget/book_details/book_details_list_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookDetails extends StatefulWidget {
  final Map<String, dynamic> selectedBook;

  const BookDetails({super.key, required this.selectedBook});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState
    extends State<BookDetails>
    with SingleTickerProviderStateMixin {

  bool isSavingDisabled = true;
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    context.read<BookDetailsCubit>()
        .getBookById(widget.selectedBook['cover_i'] ?? 0);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text( widget.selectedBook['title'] ?? AppLocale.bookDetails),
        ),
        body: _buildBookDetails()
    );
  }

  Widget _buildBookDetails() {
    final coverImage = widget.selectedBook['cover_i'].toString();
    final imageUrl = 'https://covers.openlibrary.org/b/id/$coverImage-M.jpg';

    return Column(
      children: [
        // Cover Image of the Book
        Padding(
          padding: EdgeInsets.only(top: 40.h),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2 * math.pi,
                  child: child,
                );
              },
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => Container(
                  color: Colors.grey[300],
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[300],
                  child: Icon(Icons.image_not_supported, color: Colors.grey[600]),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 50.h),

        Expanded(
            child: Column(
              children: [
                BookDetailsListTile(
                    tileKey: 'Title:',
                    value: widget.selectedBook['title']
                ),
                SizedBox(height: 8.h,),

                BookDetailsListTile(
                    tileKey: 'Subtitle:',
                    value: widget.selectedBook['subtitle'] ?? '__'
                ),
                SizedBox(height: 8.h,),

                BookDetailsListTile(
                  tileKey: 'Author:',
                  value: widget.selectedBook['author_name'] != null
                      ? (widget.selectedBook['author_name'] as List).join(', ')
                      : '',
                ),
                SizedBox(height: 8.h,),

                BookDetailsListTile(
                  tileKey: 'Language:',
                  value: widget.selectedBook['language'] != null
                      ? (widget.selectedBook['language'] as List).join(', ')
                      : '',
                ),
                SizedBox(height: 8.h,),

                BookDetailsListTile(
                  tileKey: 'Book Published:',
                  value: widget.selectedBook['first_publish_year'].toString(),
                ),

                BlocBuilder<BookDetailsCubit, BookDetailsState>(
                  builder: (context, state) {

                    if (state is BookDetailsCaptured) {
                      final capturedBookId = state.book?['id'];
                      isSavingDisabled =
                          widget.selectedBook['cover_i'] == capturedBookId;
                    }

                    if(state is BookDetailsSaved) {
                      isSavingDisabled = true;
                    }

                    if(state is BookDetailsError) {
                      isSavingDisabled = false;
                    }

                    return Padding(
                      padding: EdgeInsets.all(16.h),
                      child: ElevatedButton(
                        onPressed: !isSavingDisabled ? () {

                          // Save Book into Local Storage
                          context.read<BookDetailsCubit>()
                              .addBook(widget.selectedBook);

                        } : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 48),
                          backgroundColor: !isSavingDisabled
                              ? Palette.primaryBlue.shade500
                              : Colors.grey[500],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          !isSavingDisabled
                              ? 'Save Book into Local Storage'
                              : 'Book saved in Local Storage',
                          style: TextStyle(
                              fontSize: 16.sp,
                              color: !isSavingDisabled
                                  ? Colors.white
                                  : Colors.black
                          ),
                        ),
                      ),
                    );
                  },
                )
              ],
            )
        )
      ],
    );
  }
}
