import 'package:book_finder/config/color/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBoxWithAction extends StatefulWidget {
  final Function(String) onSearch;
  final Function() onClear;
  final String hintText;

  const SearchBoxWithAction({
    super.key,
    required this.hintText,
    required this.onSearch,
    required this.onClear
  });

  @override
  State<SearchBoxWithAction> createState() => _SearchBoxWithActionState();
}

class _SearchBoxWithActionState extends State<SearchBoxWithAction> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Palette.primaryBlue.shade50,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyle(fontSize: 20.sp),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _controller.clear();
              widget.onClear();
              setState(() {});
            },
          )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(16.w),
        ),
        onSubmitted: widget.onSearch,
        onChanged: (_) => setState(() {}),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
