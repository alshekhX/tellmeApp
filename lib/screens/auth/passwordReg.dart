import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/auth/confirmPassReq.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';

import '../../provider/auth.dart';

class PasswordRegistration extends StatefulWidget {
  const PasswordRegistration({Key? key}) : super(key: key);

  @override
  State<PasswordRegistration> createState() => _PasswordRegistrationState();
}

class _PasswordRegistrationState extends State<PasswordRegistration> {
  TextEditingController passwordC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
    bool _showPassword = false;
     void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }


@override
  void initState() {
    if (Provider.of<AuthProvider>(context, listen: false).password != null) {
      passwordC.text = Provider.of<AuthProvider>(context, listen: false).password!;
    }
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
                resizeToAvoidBottomInset: false,//use this

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 5.h),
        // ignore: prefer_const_literals_to_create_immutables
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              ' كلمة السر',
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Text(
              ' يجب الا تقل كلمة السر عن ستة رموز ويحبذ استخدام الارقام لزيادة الامان',
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
                                                 obscureText: !_showPassword,
                                                 

                controller: passwordC, validator: (value) {
                  if (value!.isEmpty) {
                    return 'لا تترك هذا الحقل فارغا';
                  }
                  if (value.length < 6) {
                    return "يجب ان لا تقل كلمة السر عن ستة حروف";
                  }
                },

                decoration: InputDecoration(
                     suffixIcon: GestureDetector(
                                    onTap: () {
                                      _togglevisibility();
                                    },
                                    child: Icon(
                                      _showPassword ? Icons.visibility : Icons
                                          .visibility_off, color: Colors.grey,size: 15.sp,),
                                  ),
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
                    labelText: ' كلمة السر',
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
                    if (_formKey.currentState!.validate()) {
                       Provider.of<AuthProvider>(context, listen: false).password =
                      passwordC.text;
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: ConfirmPassWord()));
                    }
                  },
                ),
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
                            child: UserNameReg(),
                            childCurrent: PasswordRegistration()));
                  },
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
