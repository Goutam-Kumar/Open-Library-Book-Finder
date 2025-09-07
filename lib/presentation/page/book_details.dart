import 'package:book_finder/config/color/palette.dart';
import 'package:book_finder/locale/app_locale.dart';
import 'package:book_finder/presentation/widget/book_details/book_details_list_tile.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookDetails extends StatefulWidget {
  final Map<String, dynamic> selectedBook;

  const BookDetails({super.key, required this.selectedBook});

  @override
  State<BookDetails> createState() => _BookDetailsState();
}

class _BookDetailsState extends State<BookDetails> {
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
    return Column(
      children: [
        // Cover Image of the Book
        AspectRatio(
          aspectRatio: 16 / 9,
          child: CachedNetworkImage(
            imageUrl: 'https://covers.openlibrary.org/b/id/${widget.selectedBook['cover_i']}-M.jpg',
            fit: BoxFit.cover,
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
        SizedBox(height: 16.h),

        Expanded(
            child: Column(
              children: [
                BookDetailsListTile(
                    tileKey: 'Title:',
                    value: widget.selectedBook['title']
                ),
              ],
            )
        )
      ],
    );
  }
}
