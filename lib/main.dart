import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/likesprovider.dart';
import 'package:tell_me/provider/questionProvider.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/auth/login.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';
import 'package:tell_me/screens/homePage.dart/home_Page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tell_me/screens/introScreen.dart';
import 'package:tell_me/screens/splashScreen.dart';
import 'package:tell_me/util/ad_helper.dart';
import 'package:tell_me/util/pushNoti.dart';

AppOpenAd? myAppOpenAd;

loadAppOpenAd() {
  AppOpenAd.load(
      adUnitId: AdHelper.bannerAdUnitId, //Your ad Id from admob
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (ad) {
            myAppOpenAd = ad;
            myAppOpenAd!.show();
          },
          onAdFailedToLoad: (error) {}),
      orientation: AppOpenAd.orientationPortrait);
}

Future init() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

void main() async {
  await init();

  // await WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance
    ..initialize()
    ..updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ['431972133162394FE5C8A8B5D8F019F6']),
    );
  loadAppOpenAd();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => QuestionProvider()),
    ChangeNotifierProvider(create: (context) => RecordProvider()),
    ChangeNotifierProvider(create: (context) => AuthProvider()),
    ChangeNotifierProvider(create: (context) => LikesProvider()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    // ignore: prefer_const_constructors
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('ar'),
        theme: ThemeData(
            textSelectionTheme: TextSelectionThemeData(
                cursorColor: Color(0xff00C6AB),
                selectionColor: Color(0xffC7DAE3),
                selectionHandleColor: Color(0xff37474F)),
            textTheme: GoogleFonts.vazirmatnTextTheme().apply(
              bodyColor: Color(0xff212427),
            ),
            primaryColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.white,
            )),
        title: 'Tell Me',
        home: MyHomePage(),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool alredyLogged = false;
  bool firstTime = false;
  SharedPreferences? prefs;

  //pushnotification
   String notificationTitle = 'No Title';
  String notificationBody = 'No Body';
  String notificationData = 'No Data';


  @override
  void initState() {

    //notiii
    final firebaseMessaging = FCM();
    firebaseMessaging.setNotifications();
    
    firebaseMessaging.streamCtlr.stream.listen(_changeData);
    firebaseMessaging.bodyCtlr.stream.listen(_changeBody);
    firebaseMessaging.titleCtlr.stream.listen(_changeTitle);

    // TODO: implement initState
    super.initState();
  }


  //notiiiii
  _changeData(String msg) => setState(() => notificationData = msg);
  _changeBody(String msg) => setState(() => notificationBody = msg);
  _changeTitle(String msg) => setState(() => notificationTitle = msg);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: FutureBuilder(
        future: verifyuserToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            print(firstTime);
            if (firstTime == true) {
              return IntroScreen();
            } else if (alredyLogged == true) {
              return HomePage();
            } else
              return LoginScreen();
          } else {
            return SplashScreen();
          }
        },
      ),
    );

    // This trailing comma makes auto-formatting nicer for build methods.
  }

  Future<void> verifyuserToken() async {
    try {
      await Future.delayed(Duration(seconds: 3));

      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(prefs.getString('first'));
      if (prefs.getString('first')==null) {
        firstTime = true;

        prefs.setString('first', 'in');
      }


      // if (prefs!.getString('username') != null) {
      //   print((prefs!.getString('username')));

      //   Provider.of<AuthProvider>(context, listen: false).user =
      //       MainUser(name: prefs!.getString('username'));
      //   print(Provider.of<AuthProvider>(context, listen: false).user!.name);
      // }
      // if (prefs!.getString('userid') != null) {
      //   Provider.of<AuthProvider>(context, listen: false).user!.id =
      //       prefs!.getString('userid');

      //   print(Provider.of<AuthProvider>(context, listen: false).user!.name);
      // }

      if (prefs.getString('userToken') != null) {
        Provider.of<AuthProvider>(context, listen: false).token =
            prefs.getString('userToken')!;
        String res = await Provider.of<AuthProvider>(context, listen: false)
            .getUserData();

        if (res == 'success') {
          alredyLogged = true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            duration: Duration(seconds: 2),
            backgroundColor: Colors.redAccent,
            content: Text("تأكد من تشغيل البيانات",
                style: GoogleFonts.tajawal(
                    fontSize: 12.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w400)),
          ));
          alredyLogged = false;
        }
      } else {
        
        alredyLogged = false;
      }
    } catch (e) {
      alredyLogged = false;
    }
  }
}
