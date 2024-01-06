
import 'package:flutter/material.dart';

import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/auth/controllers/NameRegC.dart';
import 'package:tell_me/screens/auth/widgets/registrationButton.dart';

class UserNameReg extends StatefulWidget {
  const UserNameReg({Key? key}) : super(key: key);

  @override
  State<UserNameReg> createState() => _UserNameRegState();
}

class _UserNameRegState extends State<UserNameReg> {

  NameRegistrationController? controller;
  @override
  void initState() {
    controller = NameRegistrationController(context);

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
          key: controller!.formKey,
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
                controller: controller!.userC,
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
                RegitrationButton(
                  title: "التالي",
                  color: Color(0xff309489),
                  iconData: Icons.arrow_left_outlined,
                  onPressed: () async {
                    await controller!.checkUserName(context);
                  },
                ),
                Spacer(),
                RegitrationButton(
                  title: 'عودة',
                  iconData: Icons.arrow_right_outlined,
                  onPressed: () async {
                                        await controller!.goBackToLogin(context);

                  },
                  color: Color(0xff37474F),
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
