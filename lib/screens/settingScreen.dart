import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:in_app_update/in_app_update.dart';

import 'package:ionicons/ionicons.dart';

import 'package:ndialog/ndialog.dart';

import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:sizer/sizer.dart';

import 'package:settings_ui/settings_ui.dart';

import 'package:tell_me/screens/classes/colors.dart';
import 'package:tell_me/screens/rulesScreen.dart';

import '../provider/auth.dart';
import 'package:about/about.dart';

import 'auth/login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AppUpdateInfo? _updateInfo;
  Future<void> checkForUpdate() async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;
      });
    }).catchError((e) {});
  }

  @override
  void initState() {
    checkForUpdate();
    // TODO: implement initState
    super.initState();
  }

  void showSnack(String text) {
    if (_scaffoldKey.currentContext != null) {
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(SnackBar(
          duration: Duration(seconds: 2),
          content: Text(text, style: GoogleFonts.tajawal())));
    }
  }

  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colorss.recorderBackground),
        title: Text(
          'الإعدادات',
          style: TextStyle(color: Color(0xff212427)),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.h),
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                trailing: Icon(
                  Ionicons.refresh_circle_outline,
                  color: Color(0xff212427),
                ),
                title: Text(
                  'البحث عن تحديث',
                  style: TextStyle(),
                ),
                onTap: _updateInfo?.updateAvailability ==
                        UpdateAvailability.updateAvailable
                    ? () {
                        InAppUpdate.performImmediateUpdate().catchError(
                            (e) => showSnack('حدث خطأ عند محاولة التحديث'));
                      }
                    : () {
                        return showSnack("لا توجد نسخة جديدة للتطبيق");
                      },
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                trailing: Icon(
                  Ionicons.information_circle_outline,
                  color: Color(0xff212427),
                ),
                title: Text(
                  "عن التطبيق",
                  style: TextStyle(),
                ),
                onTap: () async {
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
                    children: const <Widget>[
                      // MarkdownPageListTile(
                      //   icon: Icon(Icons.list),
                      //   title: Text('Changelog'),
                      //   filename: 'CHANGELOG.md',
                      // ),
                    ],
                    applicationIcon: const SizedBox(
                      width: 100,
                      height: 100,
                      child: Image(
                        image: AssetImage('assets/images/tellsplash.png'),
                      ),
                    ),
                  );
                },
              ),
            ),
                   Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                trailing: Icon(
                  Ionicons.information_circle_outline,
                  color: Color(0xff212427),
                ),
                title: Text(
                  'سياسة الخصوصية',
                  style: TextStyle(),
                ),
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Rules()));
                },
              ),
            ),
      
            Container(
              width: size.width * .9,
              child: Divider(
                thickness: 1,
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ListTile(
                trailing: Icon(
                  Ionicons.log_out_outline,
                  color: Color(0xff212427),
                ),
                title: Text(
                  'تسجيل الخروج',
                  style: TextStyle(),
                ),
                onTap: () async {
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
                },
              ),
            ),
         ],
        ),
      ),
    );
  }
}
