import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/auth/login.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';
import 'package:tell_me/screens/classes/colors.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  List<PageViewModel> ?contents;

  @override
  void initState() {
    contents = [
      PageViewModel(
        title: "شارك بصوتك الفريد",
        body: "عبر عن نفسك وشارك تجاربك وقصصك الفريدة مع مستخدمين آخرين",
        image: Center(
            child: Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: SizedBox(
              height: 180..sp,
              width: 180..sp,
              child: Image.asset('assets/images/singer.png')),
        )),
        decoration: PageDecoration(
            titleTextStyle: TextStyle(
               fontWeight: FontWeight.w600,
              fontSize: 22.sp,
          ),
          bodyTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.grey.shade600),
        ),
      ),
      PageViewModel(
        title: "إستمع للاخرين",
        body:
            "استمع إلى آراء وقصص المستخدمين الآخرين حول الحياة , الصراعات ,العلاقات والمزيد",
        image: Center(
            child: Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: SizedBox(
              height: 180..sp,
              width: 180..sp,
              child: Image.asset('assets/images/listen.png')),
        )),
        decoration: PageDecoration(
           titleTextStyle: TextStyle(
               fontWeight: FontWeight.w600,
              fontSize: 22.sp,
          ),
          bodyTextStyle: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.grey.shade600),
        ),
      ),
      PageViewModel(
        title: "Tell Me",
        body:
            "يوفر تطبيق تيل مي مكان رائع للإستماع لتجارب وآراء المستخدمين المختلفة, وقضاء وقت ممتع ",
        image: Center(
            child: Padding(
          padding: EdgeInsets.only(top: 15.h),
          child: SizedBox(
              height: 180..sp,
              width: 180..sp,
              child: Image.asset('assets/images/logoSplash.png')),
        )),
        footer: ElevatedButton(
          child: Center(
            child: Text(
              'حساب جديد',
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
            ),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 2,
            primary: Color(0xff5ABA8A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: BorderSide(width: 1.0, color: Colors.white),
            ),
          ),
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return UserNameReg();
                },
              ),
              (_) => false,
            );
          },
        ),
        decoration: PageDecoration(
           titleTextStyle: TextStyle(
               fontWeight: FontWeight.w600,
              fontSize: 30.sp,
          ),
          bodyTextStyle: TextStyle(
            
            
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
              color: Colors.grey.shade600),
        ),
      ),
    ];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Localizations.override(context: context,
        locale: Locale('en'),
        
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 5.w),
          child: IntroductionScreen(
            
              pages: contents,
              onDone: () {
                Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return LoginScreen();
                    },
                  ),
                  (_) => false,
                ); // When done button is press
              },
              showBackButton: true,
              next: Text("التالي",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colorss.recorderBackground.withOpacity(.8))),
              showNextButton: true,
              back: Icon(
                Icons.arrow_back,
                color: Colorss.recorderBackground.withOpacity(.8),
              ),
              done: 
              
              Text("تسجيل الدخول",
                  style: TextStyle(
                    fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade600))),
        ),
      ),
    );
  }
}
