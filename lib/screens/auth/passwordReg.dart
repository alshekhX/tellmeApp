import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/auth/controllers/PassRegC.dart';
import 'package:tell_me/screens/auth/widgets/registrationButton.dart';


class PasswordRegistration extends StatefulWidget {
  const PasswordRegistration({Key? key}) : super(key: key);

  @override
  State<PasswordRegistration> createState() => _PasswordRegistrationState();
}

class _PasswordRegistrationState extends State<PasswordRegistration> {
PasswordRegistrationController ?controller;
 
    bool _showPassword = false;
     void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }


@override
  void initState() {
    controller=PasswordRegistrationController();
   
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
          key: controller!.formKey,
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
              ' يجب الا تقل كلمة السر عن ستة رموز, إستخدم خليط من الأرقام والحروف لزيادة درجة الأمان ',
              style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.normal,
                  color: Colors.grey),
            ),
            SizedBox(
              height: 10.sp,
            ),
            SizedBox(
              child: TextFormField(
                                                 obscureText: !_showPassword,
                                                 

                controller: controller!.passwordC, validator: (value) {
                  if (value!.isEmpty) {
                    return 'لا تترك هذا الحقل فارغا';
                  }
                  if (value.length < 6) {
                    return "يجب ان لا تقل كلمة السر عن ستة رموز";
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

                     RegitrationButton(title: "التالي",
                color: Color(0xff309489),
                              iconData: Icons.arrow_left_outlined,

                   onPressed: () async {
                    controller!.AddPassword(context);
                  },),
         
                  Spacer(),

                      RegitrationButton(title: 'عودة', 
              iconData: Icons.arrow_right_outlined,
              
                onPressed: () async {
                  controller!.goBackToNameReg(context);
                     },color: Color(0xff37474F),)
               
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
