import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/screens/auth/passwordReg.dart';
import 'package:tell_me/screens/classes/colors.dart';
import 'package:tell_me/screens/homePage.dart/home_Page.dart';
import 'package:tell_me/util/const.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class PassConfirmRegistrationController {
  final formKey = GlobalKey<FormState>();
  bool checkValue = false;

  TextEditingController confirmPasswordC = TextEditingController();
  AuthProvider? userProvider;

  PassConfirmRegistrationController(BuildContext context) {
    userProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  registerUser(BuildContext context) async {
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
      if (checkValue == false) {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: "يجب الموافقة على الشروط والاحكام",
          ),
        );
      } else {
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
                .registerUser(userProvider!.userName!.replaceAll(' ', ''),
                    userProvider!.password!);
            print(res);
            if (res == 'success') {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setString('userToken',
                  Provider.of<AuthProvider>(context, listen: false).token!);

              pr.dismiss();
              Beamer.of(context).beamToNamed('/home',popToNamed: '/');

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
  }

  goBackToPassword(BuildContext context) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: PasswordRegistration()));
  }
}
