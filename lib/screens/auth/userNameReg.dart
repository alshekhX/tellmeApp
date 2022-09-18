import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/screens/auth/login.dart';
import 'package:tell_me/screens/auth/passwordReg.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../classes/colors.dart';

class UserNameReg extends StatefulWidget {
  const UserNameReg({Key? key}) : super(key: key);

  @override
  State<UserNameReg> createState() => _UserNameRegState();
}

class _UserNameRegState extends State<UserNameReg> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController userC = TextEditingController();

  @override
  void initState() {
    if (Provider.of<AuthProvider>(context, listen: false).userName != null) {
      userC.text = Provider.of<AuthProvider>(context, listen: false).userName!;
    }
    // TODO: implement initState
    super.initState();
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              ' إسم المستخدم',
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Text(
              ' سوف يتم إخفاء إسم المستخدم الخاص بك عن بقية المشتركين',
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
                controller: userC,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'لا تترك هذا الحقل فارغا';
                  }
                  if (value.length < 3) {
                    return "يجب ان لا يقل اسم المستخدم عن ثلاثة حروف";
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
            Row(
              children: [
                ElevatedButton(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_left_outlined),
                        Text(
                          'التالي',
                          style: TextStyle(
                              fontSize: 15.sp, fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 2,
                      primary: Color(0xff309489),
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
                                child: LoadingAnimationWidget.staggeredDotsWave(
                                    color: Colorss.recorderBackground,
                                    size: 40.sp),
                              )));
                      if (_formKey.currentState!.validate()) {
                        pr.show();

                        String internetConn = await _checkInternetConnection();

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
                                .checkUserName(userC.text);
                            print(res);
                                                      pr.dismiss();

                            if (res == 'success') {
                              Provider.of<AuthProvider>(context, listen: false)
                                  .userName = userC.text;

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: PasswordRegistration()));
                            } else if (res == 'exist') {
                              pr.dismiss();
                              showTopSnackBar(
                                context,
                                CustomSnackBar.error(
                                  message: "إسم المستخدم موجود مسبقا",
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
                            print(e);

                            showTopSnackBar(
                              context,
                              CustomSnackBar.error(
                                message: "الخادم مشغول , الرجاء المحاولة مجددا",
                              ),
                            );
                          }
                        }
                      }
                    }),
                Spacer(),
                ElevatedButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_right_outlined),
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
                            child: LoginScreen(),
                            childCurrent: UserNameReg()));
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }

  bool? _isConnected;

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
