
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';


class MainLisShimmer extends StatelessWidget {
  const MainLisShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      enabled: true,
      child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.sp),
        child: Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            CircleAvatar(
              radius: 20.sp,
              backgroundColor: Colors.grey.shade300,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 19.sp,
                child: Image.asset(
                  'assets/images/mic.png',
                  width: 10.w,
                ),
              ),
            ),

            SizedBox(
              width: 5.w,
            ),
            Container(
              color: Colors.red,
              height: 14.sp,
              width: 30.w,
              child: Text(
                '',
                style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Spacer(),
            Image.asset(
              'assets/images/red_card1.png',
              height: 18.sp,
              width: 18.sp,
            ),

            // Text(
            //   widget.type,
            //   style: TextStyle(color: Colors.grey.shade600),
            // ),
            SizedBox(width: 10.w),
          ],
        ),
      ),
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
    );
    
  }
}
