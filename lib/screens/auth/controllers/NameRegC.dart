import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/screens/auth/login.dart';
import 'package:tell_me/screens/auth/passwordReg.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';
import 'package:tell_me/screens/classes/colors.dart';
import 'package:tell_me/util/const.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class NameRegistrationController {
  final formKey = GlobalKey<FormState>();

  final TextEditingController userC = TextEditingController();

  NameRegistrationController(BuildContext context) {
    if (Provider.of<AuthProvider>(context, listen: false).userName != null) {
      userC.text = Provider.of<AuthProvider>(context, listen: false).userName!;
    }
  }

  checkUserName(BuildContext context) async {
    CustomProgressDialog pr = CustomProgressDialog(context,
        blur: 30,
        loadingWidget: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colorss.recorderBackground),
                borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: LoadingAnimationWidget.staggeredDotsWave(
                  color: Colorss.recorderBackground, size: 40.sp),
            )));

    if (formKey.currentState!.validate()) {
      pr.show();

      String internetConn = await TellMeConsts().checkInternetConnection();

      if (internetConn == 'false') {
        pr.dismiss();

        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
          ),
        );
      } else {
        try {
          String res = await Provider.of<AuthProvider>(context, listen: false)
              .checkUserName(userC.text);
          print(res);
          pr.dismiss();

          if (res == 'success') {
            Provider.of<AuthProvider>(context, listen: false).userName =
                userC.text;

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
                message: "الخادم مشغول , الرجاء المحاولة مجددا",
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
  }

  goBackToLogin(BuildContext context){
      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: LoginScreen(),
                            childCurrent: UserNameReg()));


  }
}
