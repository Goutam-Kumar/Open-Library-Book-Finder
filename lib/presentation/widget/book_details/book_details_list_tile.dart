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
          Expanded(
            flex: 2,
            child: Text(
                tileKey,
                style: _boldBodyTextStyle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis
            ),
          ),
          SizedBox(width: 8.w,),
          Expanded(
            flex: 8,
            child: Text(
                value,
                style: _normalBodyTextStyle,
                maxLines: 4,
                overflow: TextOverflow.ellipsis
            ),
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
