import 'dart:io';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/models/RecordModel.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/classes/colors.dart';
import 'package:tell_me/screens/homePage.dart/home_Page.dart';
import 'package:tell_me/screens/recorderScreen/recorder_screen.dart';
import 'package:tell_me/screens/settingScreen/settingScreen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class RecorderScreenRController {
  RecorderScreenRController() {}
//variable
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  TextEditingController titleC = TextEditingController();
  bool isRecorderReady = false;
  Uint8List? record;
  TutorialCoachMark? tutorialCoachMark;

  //keys

  GlobalKey notiicationKey = GlobalKey();
  GlobalKey recordKey = GlobalKey();
  GlobalKey lllistKey = GlobalKey();

//functions

  recorderTut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('recorderT') == null) {
      createTutorial();
      Future.delayed(Duration(seconds: 1), () {
        showTutorial(context);
      });
      prefs.setInt('recorderT', 1);
    } else if (prefs.getInt('recorderT') == 1) {
      createTutorial();
      Future.delayed(Duration(seconds: 1), () {
        showTutorial(context);
      });
      prefs.setInt('recorderT', 2);
    } else if (prefs.getInt('recorderT') == 2) {}
    // createTutorial();
    // Future.delayed(Duration(seconds: 2), showTutorial);
  }

  updateUserNotification(BuildContext context) async {
    // String token =
    //     await Provider.of<QuestionProvider>(context, listen: false).token!;
    await Provider.of<AuthProvider>(context, listen: false).getUserData();
  }

  void showTutorial(BuildContext context) {
    tutorialCoachMark!.show(context: context);
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.grey.shade900,
      textSkip: "تخطي التعليمات",
      paddingFocus: 0,
      opacityShadow: 0.8,
      onFinish: () {
        print("finish");
      },
      onClickTarget: (target) {
        print('onClickTarget: $target');
        tutorialCoachMark!.next();
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        tutorialCoachMark!.next();
        print('onClickOverlay: $target');
      },
    );
  }

//record and stop

  Future startRecording() async {
    await recorder.startRecorder(
        toFile: 'tau_file.mp4',
        sampleRate: 441000,
        codec: Codec.aacMP4,
        bitRate: 100000);
    // setState(() {});
  }

  Future stopRecording() async {
    final path = await recorder.stopRecorder();
    print(path);
    final audioFile = File(path!);
    record = await audioFile.readAsBytes();

    await playFunc(record!);
    // setState(() {});
  }

  Future<void> playFunc(Uint8List record) async {
    await player.startPlayer(fromDataBuffer: record);
  }

  Future iniRecorder(BuildContext context) async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone Permission not granted';
    } else {
      await recorder.openRecorder();
      await player.openPlayer();

      isRecorderReady = true;
      // setState(() {});
      recorderTut(context);
      recorder.setSubscriptionDuration(Duration(milliseconds: 500));
      player.setSubscriptionDuration(Duration(milliseconds: 100));
    }
  }

  recordingButtonFun() async {
    if (!recorder.isRecording) {
      await player.stopPlayer();

      await startRecording();
    } else if (recorder.isRecording) {
      await stopRecording();
    } else if (player.isPlaying == true) {
      await player.stopPlayer();
      await startRecording();
    } else {
      await startRecording();
    }
  }

  uploadButtonFun(BuildContext context) async {
    CustomProgressDialog progressDialog = CustomProgressDialog(context,
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
    progressDialog.show();

    String token = Provider.of<AuthProvider>(context, listen: false).token!;

    String res = await Provider.of<RecordProvider>(context, listen: false)
        .createRecord(titleC.text, record, token);
    progressDialog.dismiss();

    print(res);

    if (res == 'success') {
      Navigator.pop(context);
      alertDialog('تمت العملية', "تم رفع تسجيلك بنجاح ", true, context);
    } else {
      Navigator.pop(context);

      alertDialog('فشلت العملية',
          "لم يتم عمل م يتم ,شوف قصة زي الناس وحاول مجددا", false, context);
    }
  }

//consumer and stream builder Func

  FocusedMenuHolder userLikesConsumer(
      AuthProvider userLikesProvider, BuildContext context) {
    List<Record> likes = userLikesProvider.user!.records!;
    List<FocusedMenuItem> likesWidget = likes.reversed
        .toList()
        .where((element) => element.likes != 0)
        .toList()
        .map(
          (e) => FocusedMenuItem(
              title: RichText(
                text: TextSpan(
                    text: e.likes.toString(),
                    style: GoogleFonts.tajawal(
                      color: Colors.black,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: '  إعجاب في تسجيل ',
                        style: GoogleFonts.tajawal(
                            color: Colors.grey.shade700,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.normal),
                      ),
                      TextSpan(
                        text: '${e.title!}',
                        style: GoogleFonts.tajawal(
                            color: Colors.black,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold),
                      )
                    ]),
              ),

              //  Text(
              //   '  ${e.likes.toString()} إعجاب في تسجيل ${e.title!}',
              //   style: TextStyle(fontSize: 11.sp),
              // ),
              trailingIcon: Icon(Ionicons.heart_circle,
                  color: Color.fromRGBO(131, 111, 129, 1)),
              onPressed: () {}),
        )
        .toList();
    int likesCount = 0;
    for (int i = 0; i < likes.length; i++) {
      likesCount = likesCount + likes[i].likes!;
    }

    likesWidget.add(
      FocusedMenuItem(
          title: RichText(
            text: TextSpan(
              text: 'الإعدادات',
              style: GoogleFonts.tajawal(
                color: Colors.grey.shade700,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          trailingIcon:
              Icon(Ionicons.log_out_outline, color: Colors.grey.shade700),
          onPressed: () async {
            Beamer.of(context).beamToNamed('/settings', beamBackOnPop: true);
          }),
    );

    return FocusedMenuHolder(
      key: notiicationKey,
      openWithTap: true, // Open Focused-Menu on Tap rather than Long Press

      menuItems: likesWidget,
      onPressed: () async {
        await userLikesProvider.getUserData();

        // setState(() {});
      },

      child: Padding(
        padding: EdgeInsets.all(15.sp),
        child: Stack(
          children: [
            Icon(
              Icons.notifications,
              size: 20.sp,
              color: Colors.white,
            ),
            Positioned(
                top: 0,
                left: 0,
                child: CircleAvatar(
                  radius: 7,
                  backgroundColor: Color(0xff836F81),
                  child: Padding(
                    padding: const EdgeInsets.all(1.0),
                    child: AutoSizeText(
                      likesCount >= 1000
                          ? (likesCount / 1000).toInt().toString() + "k"
                          : likesCount.toString(),
                      maxLines: 1,
                      minFontSize: 4,
                      maxFontSize: 8,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

//dispose
  void dispose() {
    recorder.closeRecorder();
    player.closePlayer();
    titleC.dispose();
    // TODO: implement dispose
  }

//targets

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "target 1",
        keyTarget: recordKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            customPosition: CustomTargetContentPosition(bottom: 5, right: 10),
            builder: (context, controller) {
              return Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Container(
                  child: Text(
                    "إضغط هنا لبدء تسجيل الصوت",
                    style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        radius: 90,
        enableOverlayTab: true,
        identify: "target 2",
        keyTarget: notiicationKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "إضغط هنا لرؤية إعجابات تسجيلاتك",
                      style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                    )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );

    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "target 3",
        keyTarget: lllistKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
              padding: EdgeInsets.all(20),
              align: ContentAlign.bottom,
              child: Container(
                padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "إضغط هنا للرجوع لقائمة التسجيلات",
                      style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        identify: "target 1",
        keyTarget: recordKey,
        alignSkip: Alignment.bottomCenter,
        contents: [
          TargetContent(
            customPosition: CustomTargetContentPosition(bottom: 5, right: 10),
            builder: (context, controller) {
              return Padding(
                padding: EdgeInsets.only(top: 5.h),
                child: Container(
                  child: Text(
                    "هذا كل م تحتاجه , يمكنك الآن تسجيل أول مقطع لك (:",
                    style: GoogleFonts.tajawal(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );

    return targets;
  }

  //alertDialog

  alertDialog(String title, String message, bool menu, BuildContext context) {
    return NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: false),
      title: Text(title,
          style: GoogleFonts.tajawal(
              fontSize: 14.sp,
              color: Color(0xff707070),
              fontWeight: FontWeight.w600)),
      content: Text(message,
          style: TextStyle(
              fontSize: 11.sp,
              color: Color(0xff707070),
              fontWeight: FontWeight.w600)),
      actions: <Widget>[
        TextButton(
            child: Text(
              "موافق",
              style: GoogleFonts.tajawal(color: Color(0xff00A4EA)),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        menu == true
            ? TextButton(
                child: Text(
                  "الذهاب إلى القائمة",
                  style: GoogleFonts.tajawal(color: Color(0xff00A4EA)),
                ),
                onPressed: () {
                  // Navigator.pushReplacement(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.fade,
                  //         child: HomePage(),
                  //         childCurrent: RecorderScreen()));
                  Beamer.of(context).beamToReplacementNamed('/home');
                })
            : Container(),
      ],
    ).show(context);
  }
}
