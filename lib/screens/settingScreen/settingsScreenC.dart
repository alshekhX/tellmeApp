import 'package:about/about.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/screens/auth/login.dart';

class SettingsScreenController {
  AppUpdateInfo? _updateInfo;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  SettingsScreenController() {}

  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      _updateInfo = info;
    }).catchError((e) {});
  }

  getScaffoldKey() {
    return _scaffoldKey;
  }

  getUpdateInfoy() {
    return _updateInfo;
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(text, style: GoogleFonts.tajawal())));
    }
  }

//tile funtions
  lookForUpdate() {
    if (getUpdateInfoy()?.updateAvailability ==
        UpdateAvailability.updateAvailable) {
      InAppUpdate.performImmediateUpdate().catchError(
          // ignore: invalid_return_type_for_catch_error
          (e) => showSnack('حدث خطأ عند محاولة التحديث'));
    } else {
      return showSnack("لا توجد نسخة جديدة للتطبيق");
    }
  }


   showAboutApp(BuildContext context) async{
       showAboutPage(
                  dialog: true,
                  context: context,
                  values: {
                    'version': '1.0',
                    'year': "2022",
                  },
                  applicationLegalese: 'Copyright © Tell ME, {{ 2022 }}',
                  applicationDescription: const Text(
                    'Tell me app provide a unique way to express yourself and share your unique experiences and stories with other users by Answering well formed questions using your own voice.\n\n Answer and listen to other users  answers about life, struggles, food, relationships, and so much. More. \n\n Tell me is not a social media app, all users are anonymous only identifiable by voice it focuses on the message not the messager.\n\n Tell Me establish a more grounded environment, it present a simple yet clean and focused interface, and its a great place to learn from accumulated authentic experiences and also have a good quality fun. ',
                    textDirection: TextDirection.ltr,
                  ),
                  children: const <Widget>[],
                  applicationIcon: const SizedBox(
                    width: 100,
                    height: 100,
                    child: Image(
                      image: AssetImage('assets/images/tellsplash.png'),
                    ),
                  ),
                );
            



  }

  logOut(BuildContext context)async{
       await NDialog(
                  dialogStyle: DialogStyle(titleDivider: true),
                  title: Text('تسجيل الخروج',
                      style: GoogleFonts.tajawal(
                          fontSize: 14.sp,
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w600)),
                  content: Text("هل تريد الخروج؟",
                      style: GoogleFonts.tajawal(
                          fontSize: 11.sp,
                          color: Color(0xff707070),
                          fontWeight: FontWeight.w600)),
                  actions: <Widget>[
                    TextButton(
                        child: Text('نعم',
                            style: GoogleFonts.tajawal(
                                fontSize: 11.sp,
                                color: Colors.red,
                                fontWeight: FontWeight.w600)),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          prefs.remove('userToken');
                          Provider.of<AuthProvider>(context, listen: false)
                              .user = null;

                          Navigator.of(context, rootNavigator: true)
                              .pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (BuildContext context) {
                                return LoginScreen();
                              },
                            ),
                            (_) => false,
                          );
                        }),
                    TextButton(
                        child: Text('إلغاء',
                            style: TextStyle(
                                fontSize: 11.sp,
                                color: Color(0xff707070),
                                fontWeight: FontWeight.w600)),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                  ],
                ).show(context);
          


  }
}
