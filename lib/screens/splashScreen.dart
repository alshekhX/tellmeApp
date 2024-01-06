import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:sizer/sizer.dart';

import 'classes/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              //     gradient: LinearGradient(colors: [
              //  Colorss.recorderBackground,
              //   Color(0xff1D1D1D),
              // ], begin: Alignment.topRight, end: Alignment.bottomLeft)),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  height: 55.h,
                  child: Row(
                    children: [
                      Container(
                        width: 50.w,
                        child: Center(
                            child: LoadingAnimationWidget.beat(
                                color:
                                    Colorss.recorderBackground.withOpacity(.6),
                                size: 30.sp)),
                      ),
                      Container(
                        width: 50.w,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 6.w),
                              child: Container(
                                child: Image.asset(
                                  'assets/images/logoSplash.png',
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 4.h,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Container(
                                width: 45.w,
                                child: AutoSizeText('Tell Me',
                                    maxLines: 1,
                                    minFontSize: 35.sp,
                                    style: GoogleFonts.readexPro(
                                        letterSpacing: 0,
                                        fontSize: 37.sp,
                                        color: Color(0xff212427),
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Container(
                                width: 45.w,
                                child: Text(
                                    '\'Tell your story, Listen to others ',
                                    style: GoogleFonts.readexPro(
                                        fontSize: 8.5.sp,
                                        color: Color(0xff212427),
                                        fontWeight: FontWeight.w500)),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w),
                              child: Container(
                                width: 45.w,
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text('ورينا قصتك وأسمع قصصنا',
                                      textDirection: TextDirection.ltr,
                                      style: GoogleFonts.readexPro(
                                          fontSize: 10.5.sp,
                                          color: Color(0xff212427),
                                          fontWeight: FontWeight.w500)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 45.h,
                      child: Image.asset(
                        'assets/images/micSplash.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            )

//           Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.max,
//             children: [

//              Container(
//               width: 60.w,
//               child: Image.asset(                                        'assets/images/tellsplash.png',
// ),
//              ),

//               Container(
//                 child: Text('Tell ME',
//                     style: TextStyle(
//                             fontSize: 25.sp,
//                             color: Colors.black,
//                             fontWeight: FontWeight.w900)),
//               ),
//               SizedBox(height: 2.h),
//               Container(

//                 child: Center(
//                   child: Text('Tell your story and Listen to others',
//                       style: TextStyle(
//                               fontSize: 15.sp,
//                               color: Colors.grey.shade500,
//                               fontWeight: FontWeight.w600)),
//                 ),
//               ),
//               SizedBox(
//                 height: 2.h,
//               ),

//               SizedBox(
//                 height: 1.h,
//               ),
//               SizedBox(height: 8.h),
//             ],
//           ),

            ),
      ),
    );
  }
}
