import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';

import 'classes/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

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
color:            Color(0xff887D99),

          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
             
             Container(
              width: 25.w,
              child: Image.asset(                                        'assets/images/microphone3.png',
),
             ),
                             SizedBox(height: 1.h),

              Container(
                child: Text('Tell ME',
                    style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
              ),
              SizedBox(height: 4.h),
              Container(
               
                child: Text('Tell your story and Listen to others',
                    style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w300)),
              ),
              SizedBox(
                height: 2.h,
              ),
            
              SizedBox(
                height: 1.h,
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  
  }
}