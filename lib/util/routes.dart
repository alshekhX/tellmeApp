import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:tell_me/main.dart';
import 'package:tell_me/provider/settingProvider.dart';
import 'package:tell_me/screens/auth/confirmPassReq.dart';
import 'package:tell_me/screens/auth/login.dart';
import 'package:tell_me/screens/auth/passwordReg.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';
import 'package:tell_me/screens/homePage.dart/home_Page.dart';
import 'package:tell_me/screens/recorderScreen/recorder_screen.dart';
import 'package:tell_me/screens/rulesScreen.dart';
import 'package:tell_me/screens/settingScreen/settingScreen.dart';
import 'package:tell_me/screens/settingScreen/widgets/SettingsTile.dart';
import 'package:tell_me/screens/splashScreen.dart';
import 'package:tell_me/screens/terms.dart';

class TellMeRoutes {
  static BeamerDelegate routerDelegate = BeamerDelegate(
    
    locationBuilder: RoutesLocationBuilder(
      routes: {
        // Return either Widgets or BeamPages if more customization is needed
        '/': (context, state, data) => MyHomePage(),
        '/home': (context, state, data) => HomePage(),
        '/login': (context, state, data) => LoginScreen(),
        '/signup': (context, state, data) => UserNameReg(),
        '/signup/password': (context, state, data) => PasswordRegistration(),
        '/signup/password/confirm': (context, state, data) => ConfirmPassWord(),
        '/recorder': (context, state, data) => RecorderScreen(),
        '/splash': (context, state, data) => SplashScreen(),
        '/settings': (context, state, data) => Settings(),
        '/settings/rules': (context, state, data) => Rules(),
        '/settings/terms': (context, state, data) => Terms(),

      },
    ),
  );
}
