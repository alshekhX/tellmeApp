import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';
import 'package:tell_me/screens/homePage.dart/home_Page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../provider/auth.dart';
import '../classes/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  GlobalKey cardKey = GlobalKey();
  GlobalKey buttonKey = GlobalKey();
  // GlobalKey keyButton2 = GlobalKey();
  // GlobalKey keyButton3 = GlobalKey();
  // GlobalKey keyButton4 = GlobalKey();
  // GlobalKey keyButton5 = GlobalKey();

  Future<String> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
        });
        return 'success';
      }
      return 'success';
    } 

    on

     SocketException catch (err) {
      return 'false';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //use this

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 5.h),
        // ignore: prefer_const_literals_to_create_immutables
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              height: 85.h,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20.sp,
                    ),
                    Text(
                      "تسجيل الدخول",
                      style: TextStyle(
                          fontSize: 30.sp, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20.sp,
                    ),
                    SizedBox(
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'لا تترك هذا الحقل فارغا';
                          }
                          if (value.length < 3) {
                            return "يجب ان لا يقل اسم المستخدم عن تلاتة حروف";
                          }
                        },
                        controller: userC,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 2.w),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.6), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.6), width: 1),
                            ),
                            labelText: 'إسم المستخدم',
                            labelStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Color(0xffB9B9B9),
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    SizedBox(
                      height: 10.sp,
                    ),
                    SizedBox(
                      child: TextFormField(
                        controller: passwordC,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'لا تترك هذا الحقل فارغا';
                          }
                          if (value.length < 6) {
                            return "يجب ان لا تقل كلمة السر عن ستة حروف";
                          }
                        },
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0, horizontal: 2.w),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.6), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(.6), width: 1),
                            ),
                            labelText: "كلمة السر",
                            labelStyle: TextStyle(
                                fontSize: 10.sp,
                                color: Color(0xffB9B9B9),
                                fontWeight: FontWeight.w400)),
                      ),
                    ),
                    SizedBox(
                      height: 15.sp,
                    ),
                    ElevatedButton(
                      child: Text(
                        'سجل دخولك',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.normal,color: Colors.white),
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
                        CustomProgressDialog pr = CustomProgressDialog(context,
                            blur: 30,
                            loadingWidget: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colorss.recorderBackground),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(25),
                                  child:
                                      LoadingAnimationWidget.staggeredDotsWave(
                                          color: Colorss.recorderBackground,
                                          size: 40.sp),
                                )));

                        if (_formKey.currentState!.validate()) {
                          pr.show();

                          String internetConn =
                              await _checkInternetConnection();

                          if (internetConn == 'false') {
                            pr.dismiss();
                            setState(() {});

                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message:
                                    "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
                              ),
                            );
                          } else {
                            try {
                              String res = await Provider.of<AuthProvider>(
                                      context,
                                      listen: false)
                                  .signIN(userC.text.replaceAll(' ', ''),
                                      passwordC.text);
                              print(res);
                              if (res == 'success') {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                prefs.setString(
                                    'userToken',
                                    Provider.of<AuthProvider>(context,
                                            listen: false)
                                        .token!);

                                pr.dismiss();

                               Beamer.of(context).beamToReplacementNamed('/home',popToNamed: '/');
                              } else if (res == '400') {
                                pr.dismiss();
                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message:
                                        "البيانات المدخلة خاطئة, تأكد من المدخلات وحاول مجددا",
                                  ),
                                );
                              } else {
                                pr.dismiss();

                                showTopSnackBar(
                                  context,
                                  CustomSnackBar.error(
                                    message:
                                        "الخادم مشغول , الرجاء المحاولة مجددا",
                                  ),
                                );
                              }
                            } catch (e) {
                              pr.dismiss();

                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message:
                                      "الخادم مشغول , الرجاء المحاولة مجددا",
                                ),
                              );
                            }
                          }
                        }
                      },
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                child: UserNameReg()));
                      },
                      child: Text(
                        "لا تمتلك حسابا؟ سجل هنا",
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade600),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
