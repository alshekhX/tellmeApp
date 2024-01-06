import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/screens/auth/confirmPassReq.dart';
import 'package:tell_me/screens/auth/passwordReg.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';

class PasswordRegistrationController {
  final formKey = GlobalKey<FormState>();

  TextEditingController passwordC = TextEditingController();

  NameRegistrationController(BuildContext context) {
    if (Provider.of<AuthProvider>(context, listen: false).password != null) {
      passwordC.text =
          Provider.of<AuthProvider>(context, listen: false).password!;
    }
  }

  AddPassword(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      Provider.of<AuthProvider>(context, listen: false).password =
          passwordC.text;
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: ConfirmPassWord()));
    }
  }

  goBackToNameReg(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: UserNameReg(),
            childCurrent: PasswordRegistration()));
  }
}
