import 'package:book_finder/config/color/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookDetailsListTile extends StatelessWidget {

  final String tileKey;
  final String value;

  const BookDetailsListTile({super.key, required this.tileKey, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric( horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tileKey,
            style: _boldBodyTextStyle,
            maxLines: 2,
          ),
          Text(
            value,
            style: _normalBodyTextStyle,
            maxLines: 4,
          )
        ],
      ),
    );
  }
}

TextStyle _boldBodyTextStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight:  FontWeight.bold,
    color: Palette.primaryBlue.shade800
);

TextStyle _normalBodyTextStyle = TextStyle(
    fontSize: 18.sp,
    fontWeight:  FontWeight.normal,
    color: Palette.primaryBlue.shade400
);
