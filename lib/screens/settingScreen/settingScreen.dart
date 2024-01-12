import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:in_app_update/in_app_update.dart';
import 'package:ionicons/ionicons.dart';
import 'package:ndialog/ndialog.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/screens/classes/colors.dart';
import 'package:tell_me/screens/rulesScreen.dart';
import 'package:tell_me/screens/settingScreen/settingsScreenC.dart';
import 'package:tell_me/screens/settingScreen/widgets/SettingsTile.dart';
import 'package:tell_me/screens/terms.dart';
import '../../provider/auth.dart';
import 'package:about/about.dart';
import '../auth/login.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  late SettingsScreenController controller;

  @override
  void initState() {
    controller = SettingsScreenController();
    checkForUpdate();
    // TODO: implement initState
    super.initState();
  }

  checkForUpdate() async {
    await controller.checkForUpdate();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: controller.getScaffoldKey(),
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
            SettingTile(
              title: 'البحث عن تحديث',
              iconData: Ionicons.refresh_circle_outline,
              onTap: controller.getUpdateInfoy()?.updateAvailability ==
                      UpdateAvailability.updateAvailable
                  ? () {
                      InAppUpdate.performImmediateUpdate().catchError(
                          // ignore: invalid_return_type_for_catch_error
                          (e) => controller
                              .showSnack('حدث خطأ عند محاولة التحديث'));
                    }
                  : () {
                      print('jk');
                      return controller.showSnack("لا توجد نسخة جديدة للتطبيق");
                    },
            ),
            SettingTile(
              title: "عن التطبيق",
              iconData: Ionicons.information_circle_outline,
              onTap: () async {
             controller.showAboutApp(context);
              },
            ),
            SettingTile(
              title: 'سياسة الخصوصية',
              iconData: Ionicons.person_circle_outline,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Rules()));
              },
            ),
            SettingTile(
              title: ' الشروط والأحكام',
              iconData: Ionicons.checkmark_circle_outline,
              onTap: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Terms()));
              },
            ),
            SettingTile(
              iconData: Ionicons.share_social_outline,
              title: ' مشاركة التطبيق',
              onTap: () async {
                Share.share(
                    'https://play.google.com/store/apps/details?id=com.alshekh.tell_me');
              },
            ),
            Container(
              width: size.width * .9,
              child: Divider(
                thickness: 1,
              ),
            ),
            SettingTile(
              title: 'تسجيل الخروج',
              iconData: Ionicons.log_out_outline,
              onTap: () async {
                await controller.logOut(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
