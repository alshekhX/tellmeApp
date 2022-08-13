import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/likesprovider.dart';
import 'package:tell_me/provider/questionProvider.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/auth/login.dart';
import 'package:tell_me/screens/auth/userNameReg.dart';
import 'package:tell_me/screens/home_Page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';





void main() {
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
          selectionHandleColor: Color(0xff37474F)
        ),
              textTheme: GoogleFonts.vazirmatnTextTheme().apply(
                bodyColor:  Color(0xff212427),
                
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





  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return LoginScreen();
    // This trailing comma makes auto-formatting nicer for build methods.
  }
}
