
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/auth/controllers/ConfirmPassC.dart';
import 'package:tell_me/screens/auth/widgets/registrationButton.dart';
import 'package:tell_me/screens/terms.dart';


class ConfirmPassWord extends StatefulWidget {
  const ConfirmPassWord({Key? key}) : super(key: key);

  @override
  State<ConfirmPassWord> createState() => _ConfirmPassWordState();
}

class _ConfirmPassWordState extends State<ConfirmPassWord> {
  PassConfirmRegistrationController? controller;
  TextEditingController confirmPasswordC = TextEditingController();
  bool _showPassword = false;
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  @override
  void initState() {
    controller = PassConfirmRegistrationController(context);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //use this

      body: Padding(
        padding: EdgeInsets.fromLTRB(10.w, 10.h, 10.w, 10.h),
        // ignore: prefer_const_literals_to_create_immutables
        child: Form(
          key: controller!.formKey,
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
                obscureText: !_showPassword,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'لا تترك هذا الحقل فارغا';
                  }
                  if (value != controller!.userProvider!.password) {
                    return "كلمة السر لا تتطابق";
                  }
                },
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        _togglevisibility();
                      },
                      child: Icon(
                        _showPassword ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                        size: 15.sp,
                      ),
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
                RegitrationButton(
                  title: "التالي",
                  color: controller!.checkValue == true
                      ? Color(0xff5ABA8A)
                      : Colors.grey.shade500,
                  iconData: Icons.arrow_left_outlined,
                  onPressed: () async {
                    await controller!.registerUser(context);
                  },
                ),
                Spacer(),
                RegitrationButton(
                  title: 'عودة',
                  iconData: Icons.arrow_right_outlined,
                  onPressed: () async {
                    await controller!.goBackToPassword(context);
                  },
                  color: Color(0xff37474F),
                )
              ],
            ),
            Row(children: <Widget>[
              Container(
                width: 30.sp,
                child: Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  value: controller!.checkValue,
                  onChanged: (bool? value) {
                    setState(() {
                      controller!.checkValue = value!;
                    });
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Terms()));
                },
                child: Container(
                  child: Text(
                    'الموافقة على الشروط والأحكام ',
                    style:
                        TextStyle(fontSize: 11.sp, color: Colors.grey.shade600),
                  ),
                ),
              ),
            ])
          ]),
        ),
      ),
    );
  }
}
