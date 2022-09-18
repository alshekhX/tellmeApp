import 'dart:io';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
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
import 'package:lottie/lottie.dart';
import 'package:tell_me/models/RecordModel.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/provider/settingProvider.dart';
import 'package:tell_me/screens/auth/login.dart';
import 'package:tell_me/screens/classes/colors.dart';
import 'package:tell_me/screens/home_Page.dart';
import 'package:tell_me/screens/settingScreen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../provider/auth.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({Key? key}) : super(key: key);

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  final recorder = FlutterSoundRecorder();
  final player = FlutterSoundPlayer();
  TextEditingController titleC = TextEditingController();
  bool isRecorderReady = false;
  Uint8List? record;

  @override
  void initState() {
    iniRecorder();
    updateUserNotification();


    // TODO: implement initState
    super.initState();
  }

  void recorderTut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('recorderT') == null) {
      createTutorial();
      Future.delayed(Duration(seconds: 1), showTutorial);
      prefs.setInt('recorderT', 1);
    } else if (prefs.getInt('recorderT') == 1) {
      createTutorial();
      Future.delayed(Duration(seconds: 1), showTutorial);
      prefs.setInt('recorderT', 2);
    } else if (prefs.getInt('recorderT') == 2) {


    }
    // createTutorial();
    // Future.delayed(Duration(seconds: 2), showTutorial);
  }

  updateUserNotification() async {
    // String token =
    //     await Provider.of<QuestionProvider>(context, listen: false).token!;
    await Provider.of<AuthProvider>(context, listen: false).getUserData();
  }

  void showTutorial() {
    tutorialCoachMark!.show(context: context);
  }

  TutorialCoachMark? tutorialCoachMark;
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
      onSkip: () {
        print("skip");
      },
    );
  }

  @override
  void dispose() {
    recorder.closeRecorder();
    player.closePlayer();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return WillPopScope(
      onWillPop: () async {
        return await NAlertDialog(
          dialogStyle: DialogStyle(titleDivider: false),
          title: Text(
            "تاكيد الخروج",
            style:
                GoogleFonts.tajawal(color: Colorss.dialogtext, fontSize: 16.sp),
          ),
          content: Text(
            " هل تريد الخروج من البرنامج؟",
            style:
                GoogleFonts.tajawal(color: Colorss.dialogtext, fontSize: 16.sp),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "نعم",
                style: GoogleFonts.tajawal(
                    color: Color.fromARGB(247, 78, 162, 120)),
              ),
              onPressed: () => Navigator.pop(context, true),
            ),
            TextButton(
              child: Text(
                "إلغاء",
                style: GoogleFonts.tajawal(color: Color(0xff00A4EA)),
              ),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ).show(context);
      },
      child: Scaffold(
        backgroundColor: Colorss.recorderBackground,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: isRecorderReady
                ? Column(
                    children: [
                      Row(
                        children: [
                          Align(
                              alignment: Alignment.centerLeft,
                              child: Consumer<AuthProvider>(
                                builder: (context, userLikesProvider, _) {
                                  List<Record> likes =
                                      userLikesProvider.user!.records!;
                                  List<FocusedMenuItem> likesWidget = likes.reversed.toList()
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
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color: Colors.grey
                                                                  .shade700,
                                                              fontSize: 8.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    TextSpan(
                                                      text: '${e.title!}',
                                                      style:
                                                          GoogleFonts.tajawal(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 9.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                    )
                                                  ]),
                                            ),

                                            //  Text(
                                            //   '  ${e.likes.toString()} إعجاب في تسجيل ${e.title!}',
                                            //   style: TextStyle(fontSize: 11.sp),
                                            // ),
                                            trailingIcon: Icon(
                                                Ionicons.heart_circle,
                                                color: Color.fromRGBO(
                                                    131, 111, 129, 1)),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomePage()));
                                            }),
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

                                        //  Text(
                                        //   '  ${e.likes.toString()} إعجاب في تسجيل ${e.title!}',
                                        //   style: TextStyle(fontSize: 11.sp),
                                        // ),
                                        trailingIcon: Icon(
                                            Ionicons.log_out_outline,
                                            color: Colors.grey.shade700),
                                        onPressed: () async {

                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Settings()));
                                           }),
                                  );
                              





                                  return FocusedMenuHolder(
                                    key: notiicationKey,
                                    openWithTap:
                                        true, // Open Focused-Menu on Tap rather than Long Press

                                    menuItems: likesWidget,
                                    onPressed: () async {
                                      await userLikesProvider.getUserData();

                                      setState(() {});
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
                                                backgroundColor:
                                                    Color(0xff836F81),
                                                child: Text(
                                                  likesCount.toString(),
                                                  style:
                                                      TextStyle(fontSize: 7.sp),
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )),
                          Spacer(),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              key: lllistKey,
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.topToBottom,
                                        child: HomePage(),
                                        childCurrent: RecorderScreen()));
                              },
                              child: Padding(
                                padding: EdgeInsets.all(15.sp),
                                child: Icon(
                                  Icons.menu,
                                  size: 20.sp,
                                  color: Colorss.recordertimerColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      SizedBox(
                        height: 10.h,
                        child: !recorder.isRecording
                            ? DefaultTextStyle(
                                style: GoogleFonts.lalezar(
                                  fontSize: 30.sp,
                                  color: Colors.white,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 7.0,
                                      color: Colors.white,
                                      offset: Offset(0, 0),
                                    ),
                                  ],
                                ),
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    FlickerAnimatedText(user!.username!,textStyle: TextStyle()),
                                    
                                  ],
                                  onTap: () {
                                    print("Tap Event");
                                  },
                                ),
                              )
                            : Container(),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        height: 120.sp,
                        width: 120.sp,
                        child: FloatingActionButton(
                          
                            backgroundColor: Colorss.recorderfloatingbackground,
                            elevation: 0,
                            onPressed: () async {
                              if (!recorder.isRecording) {
                                await player.stopPlayer();

                                await startRecording();
                                setState(() {});
                              } else if (recorder.isRecording) {
                                await stopRecording();
                                setState(() {});
                              } else if (player.isPlaying == true) {
                                await player.stopPlayer();
                                await startRecording();
                                setState(() {});
                              } else {
                                await startRecording();
                              }
                            },
                            child: player.isPlaying
                                ? Consumer<RecordProvider>(
                                    builder: ((context, value, _) {
                                      return Container(
                                        child: Icon(Ionicons.repeat,size: 100.sp,color: Colorss.recorderBackground,)
                                        
                                        // Lottie.asset(
                                        //     'assets/lotti/speakerRecorder.json',
                                        //     height: 200.sp,
                                        //     width: 200.sp,
                                        //     animate: value.lottiAnime),



                                      );
                                    }),
                                  )
                                : recorder.isRecording
                                    ? Icon(
                                        Ionicons.stop,
                                        color: Colorss.recorderfloatingIcon,
                                        size: 90.sp,
                                      )
                                    : 
                                    Icon(
                                        Ionicons.mic,
                                        color: Colorss.recorderfloatingIcon,
                                        size: 100.sp,
                                        key: recordKey,

                                      )
                                    
                                    // Image.asset(
                                    //     'assets/images/microphone3.png',
                                    //     height: 100.sp,
                                    //     key: recordKey,
                                    //   )

                            // Icon(
                            //     Icons.mic,
                            //     color: Colorss.recorderfloatingIcon,
                            //     size: 100.sp,
                            //   )

                            ),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),

                      player.isPlaying == true || player.isPaused == true
                          ? StreamBuilder<PlaybackDisposition>(
                              builder: (context, snapShot) {
                                final durationState = snapShot.data;
                                final progress = snapShot.data == null
                                    ? Duration.zero
                                    : snapShot.data!.position;

                                final total =
                                    durationState?.duration ?? Duration.zero;

                                return Container(
                                  width: 70.w,
                                  child: ProgressBar(
                                    thumbColor:
                                        Color(0xffF2962F),
                                    progressBarColor: Color(0xffF2962F),
                                    baseBarColor:
                                        Color(0xffF2962F).withOpacity(.7),
                                    progress: progress,
                                    barHeight: 1.sp,
                                    total: total,
                                    timeLabelTextStyle:
                                        TextStyle(color: Colorss.recordertext),
                                    onSeek: (duration) async {
                                      if (player.isStopped) {
                                        await player.startPlayer(
                                            fromDataBuffer: record);

                                        await player.seekToPlayer(duration);
                                        setState(() {});
                                      } else {
                                        await player.seekToPlayer(duration);
                                        setState(() {});
                                      }
                                    },
                                  ),
                                );
                              },
                              stream: player.onProgress,
                            )
                          : StreamBuilder<RecordingDisposition>(
                              builder: (context, snapShot) {
                                final duration = snapShot.hasData
                                    ? snapShot.data!.duration
                                    : Duration.zero;
                                String twoDigit(int n) =>
                                    n.toString().padLeft(2, '0');

                                final twoDigitMinits =
                                    twoDigit(duration.inMinutes.remainder(60));

                                final twoDigitSecound =
                                    twoDigit(duration.inSeconds.remainder(60));

                                if (duration.inSeconds >= 120) {
                                  stopRecording();
                                }
                                return Text(
                                  '$twoDigitMinits:$twoDigitSecound',
                                  style: TextStyle(
                                      color: Colorss.recordertimerColor,
                                      fontSize: 30.sp),
                                );
                              },
                              stream: recorder.onProgress,
                            ),

                      // Container(
                      //   child: TextField(controller: titleC),
                      // ),
                      recorder.isRecording
                          ? Lottie.asset(
                              'assets/lotti/waves.json',
                              delegates: LottieDelegates(
                                values: [
                                  ValueDelegate.color(
                                      ['recording spectrum_MAIN', 'fill'],
                                      value: Colors.black),
                                ],
                              ),
                              width: 50.w,
                              height: 25.h,
                              fit: BoxFit.fill,
                            )
                          : Container(),
                      Spacer(),
                      recorder.isRecording == false && record != null
                          ? Container(
                              width: 140.sp,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 10,
                                    primary: Colorss.recordertimerColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                      side: BorderSide(
                                          width: 1.0, color: Colors.white),
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (player.isPlaying) {
                                      await player.stopPlayer();
                                    }

                                    await NAlertDialog(
                                      dialogStyle:
                                          DialogStyle(titleDivider: false),
                                      title: Text(
                                        "اكتب عنونا للتسجيل",
                                        style: GoogleFonts.tajawal(
                                            color: Colorss.dialogtext),
                                      ),
                                      content: TextField(
                                        controller: titleC,
                                        inputFormatters: [
                                          LengthLimitingTextInputFormatter(18),
                                        ],
                                        decoration: InputDecoration(
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    vertical: 0,
                                                    horizontal: 2.w),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(.6),
                                                  width: 1),
                                            ),
                                            labelText: 'العنوان',
                                            labelStyle: GoogleFonts.tajawal(
                                                fontSize: 10.sp,
                                                color: Color(0xffB9B9B9),
                                                fontWeight: FontWeight.w400)),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            child: Text(
                                              "إرسال التسجيل",
                                              style: GoogleFonts.tajawal(
                                                  color: Color.fromARGB(
                                                      247, 78, 162, 120),fontSize: 12.sp
                                                      ),
                                            ),
                                            onPressed: () async {
                                              CustomProgressDialog
                                                  progressDialog =
                                                  CustomProgressDialog(context,
                                                      blur: 30,
                                                      loadingWidget: Container(
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border.all(
                                                                  color: Colorss
                                                                      .recorderBackground),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(25),
                                                            child: LoadingAnimationWidget
                                                                .staggeredDotsWave(
                                                                    color: Colorss
                                                                        .recorderBackground,
                                                                    size:
                                                                        40.sp),
                                                          )));
                                              progressDialog.show();

                                              String token =
                                                  Provider.of<AuthProvider>(
                                                          context,
                                                          listen: false)
                                                      .token!;

                                              String res = await Provider.of<
                                                          RecordProvider>(
                                                      context,
                                                      listen: false)
                                                  .createRecord(titleC.text,
                                                      record, token);
                                              progressDialog.dismiss();

                                              print(res);

                                              if (res == 'success') {
                                                Navigator.pop(context);

                                                alertDialog(
                                                    'تمت العملية',
                                                    "تم رفع تسجيلك بنجاح ",
                                                    true);
                                              } else {
                                                Navigator.pop(context);

                                                alertDialog(
                                                    'فشلت العملية',
                                                    "لم يتم عمل م يتم ,شوف قصة زي الناس وحاول مجددا",
                                                    false);
                                              }
                                            }),
                                        TextButton(
                                            child: Text(
                                              "إعادة التسجيل",
                                              style: GoogleFonts.tajawal(
                                                  color: Color(0xff00A4EA),fontSize: 12.sp),
                                            ),
                                            onPressed: () async {
                                              Navigator.pop(context);
                                              await startRecording();
                                            }),
                                      ],
                                    ).show(context);
                                  },
                                  child: Text(
                                    'حفظ',
                                    style: TextStyle(
                                        color: Colorss.buttontext,
                                        fontSize: 16.sp),
                                  )),
                            )
                          : Container(),
                      SizedBox(
                        height: 3.h,
                      )
                    ],
                  )
                :LoadingAnimationWidget.beat(
                        color: Colorss.recorderText, size: 40.sp)
          ),
        ),
      ),
    );
  }

  Future startRecording() async {
    await recorder.startRecorder(
        toFile: 'tau_file.mp4',
        sampleRate: 441000,
        codec: Codec.aacMP4,
        bitRate: 100000);
    setState(() {});
  }

  Future stopRecording() async {
    final path = await recorder.stopRecorder();
    print(path);
    final audioFile = File(path!);
    record = await audioFile.readAsBytes();

    await playFunc(record!);
    setState(() {});
  }

  Future<void> playFunc(Uint8List record) async {
    await player.startPlayer(fromDataBuffer: record);
  }

  Future iniRecorder() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      throw 'Microphone Permission not granted';
    } else {
      await recorder.openRecorder();
      await player.openPlayer();

      isRecorderReady = true;
      setState(() {});
      recorderTut();
      recorder.setSubscriptionDuration(Duration(milliseconds: 500));
      player.setSubscriptionDuration(Duration(milliseconds: 100));
    }
  }

  alertDialog(String title, String message, bool menu) {
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
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          type: PageTransitionType.fade,
                          child: HomePage(),
                          childCurrent: RecorderScreen()));
                })
            : Container(),
      ],
    ).show(context);
  }

  GlobalKey notiicationKey = GlobalKey();
  GlobalKey recordKey = GlobalKey();
  GlobalKey lllistKey = GlobalKey();

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
}
