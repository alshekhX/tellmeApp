import 'dart:io';

import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/auth/passwordReg.dart';
import 'package:tell_me/screens/home_Page.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../provider/auth.dart';
import '../classes/colors.dart';

class ConfirmPassWord extends StatefulWidget {
  const ConfirmPassWord({Key? key}) : super(key: key);

  @override
  State<ConfirmPassWord> createState() => _ConfirmPassWordState();
}

class _ConfirmPassWordState extends State<ConfirmPassWord> {
  TextEditingController confirmPasswordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool? _isConnected;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
          resizeToAvoidBottomInset: false,//use this

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
        // ignore: prefer_const_literals_to_create_immutables
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              'أكد كلمة السر',
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Text(
              '  كرر كتابة كلمة السر',
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 10.sp,
            ),
            SizedBox(
              child: TextFormField(
                controller: confirmPasswordC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'لا تترك هذا الحقل فارغا';
                  }
                  if (value != userProvider.password) {
                    print(value + userProvider.password!);
                    return "كلمة السر لا تتطابق";
                  }
                },
                decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 2.w),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.6), width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.grey.withOpacity(.6), width: 1),
                    ),
                    labelText: 'أكد كلمة السر',
                    labelStyle: TextStyle(
                        fontSize: 10.sp,
                        color: Color(0xffB9B9B9),
                        fontWeight: FontWeight.w400)),
              ),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Row(
              children: [
                ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swipe_right_alt),
                      
                      Text(
                        'تسجيل',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.normal),
                      ),
                    ],
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
                  CustomProgressDialog pr =
                          CustomProgressDialog(context, blur: 30,loadingWidget: Container(
                            decoration: BoxDecoration(
                                                          color: Colors.white,

                              border: Border.all(color:Colorss.recorderBackground ),
                              borderRadius: BorderRadius.circular(20)
                            ),
                            
                            child: Padding(
                              padding: const EdgeInsets.all(25),
                              child: LoadingAnimationWidget.staggeredDotsWave(color:Colorss.recorderBackground, size: 40.sp),
                            )));if (_formKey.currentState!.validate()) {
                      pr.show();

                      String internetConn = await _checkInternetConnection();

                      if (internetConn == 'false') {
                        pr.dismiss();
                        setState(() {});

                        showTopSnackBar(
                          context,
                          CustomSnackBar.error(
                            message: "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
                          ),
                        );
                      } else {
                        try {
                          String res = await Provider.of<AuthProvider>(context,
                                  listen: false)
                              .registerUser(
                                  userProvider.userName!.replaceAll(' ', ''),
                                  userProvider.password!);
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

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => HomePage()),
                                (route) => false);
                          } else {
                            pr.dismiss();
                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message: "$res خطأ في التسجيل",
                              ),
                            );
                          }
                        } catch (e) {
                          pr.dismiss();

                          showTopSnackBar(
                            context,
                            CustomSnackBar.error(
                              message: "$e",
                            ),
                          );
                        }
                      }
                    }
                  },
                ),
                Spacer(),
                ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.swipe_left_alt),
                      Text(
                        'رجوع',
                        style: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 2,
                    primary: Color(0xff37474F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                      side: BorderSide(width: 1.0, color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: PasswordRegistration()));
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<String> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
        return 'success';
      }
      return 'success';
    } on SocketException catch (err) {
      return 'false';
    }
  }
}
