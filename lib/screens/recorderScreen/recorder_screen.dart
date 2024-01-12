import 'dart:io';
import 'dart:typed_data';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:tell_me/screens/homePage.dart/home_Page.dart';
import 'package:tell_me/screens/recorderScreen/recorderScreenC.dart';
import 'package:tell_me/screens/settingScreen/settingScreen.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

import '../../provider/auth.dart';

class RecorderScreen extends StatefulWidget {
  const RecorderScreen({Key? key}) : super(key: key);

  @override
  State<RecorderScreen> createState() => _RecorderScreenState();
}

class _RecorderScreenState extends State<RecorderScreen> {
  late RecorderScreenRController controller;

  @override
  void initState() {
    controller = RecorderScreenRController();
    iniRecorder();
    updateUserNotification();

    // TODO: implement initState
    super.initState();
  }

  iniRecorder() async {
    await controller.iniRecorder(context);
    setState(() {});
  }

  updateUserNotification() async {
    controller.updateUserNotification(context);
    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
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
              child: controller.isRecorderReady
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Consumer<AuthProvider>(
                                  builder: (context, userLikesProvider, _) {
                                    return controller.userLikesConsumer(
                                        userLikesProvider, context);
                                  },
                                )),
                            Spacer(),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: InkWell(
                                key: controller.lllistKey,
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
                          child: controller.recorder.isRecording
                              ? DefaultTextStyle(
                                  style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w300,
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
                                      FlickerAnimatedText(user!.username!,
                                          textStyle: TextStyle()),
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
                              backgroundColor:
                                  Colorss.recorderfloatingbackground,
                              elevation: 0,
                              onPressed: () async {
                                await controller.recordingButtonFun();
                                setState(() {});
                              },
                              child: controller.player.isPlaying
                                  ? Consumer<RecordProvider>(
                                      builder: ((context, value, _) {
                                        return Container(
                                            child: Icon(
                                          Ionicons.repeat,
                                          size: 100.sp,
                                          color: Colorss.recorderBackground,
                                        )

                                            // Lottie.asset(
                                            //     'assets/lotti/speakerRecorder.json',
                                            //     height: 200.sp,
                                            //     width: 200.sp,
                                            //     animate: value.lottiAnime),

                                            );
                                      }),
                                    )
                                  : controller.recorder.isRecording
                                      ? Icon(
                                          Ionicons.stop,
                                          color: Colorss.recorderfloatingIcon,
                                          size: 90.sp,
                                        )
                                      : Icon(
                                          Ionicons.mic,
                                          color: Colorss.recorderfloatingIcon,
                                          size: 100.sp,
                                          key: controller.recordKey,
                                        )),
                        ),
                        SizedBox(
                          height: 3.h,
                        ),

                        controller.player.isPlaying == true ||
                                controller.player.isPaused == true
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
                                      thumbColor: Color(0xffF2962F),
                                      progressBarColor: Color(0xffF2962F),
                                      baseBarColor:
                                          Color(0xffF2962F).withOpacity(.7),
                                      progress: progress,
                                      barHeight: 1.sp,
                                      total: total,
                                      timeLabelTextStyle: TextStyle(
                                          color: Colorss.recordertext),
                                      onSeek: (duration) async {
                                        if (controller.player.isStopped) {
                                          await controller.player.startPlayer(
                                              fromDataBuffer:
                                                  controller.record);

                                          await controller.player
                                              .seekToPlayer(duration);
                                          setState(() {});
                                        } else {
                                          await controller.player
                                              .seekToPlayer(duration);
                                          setState(() {});
                                        }
                                      },
                                    ),
                                  );
                                },
                                stream: controller.player.onProgress,
                              )
                            : StreamBuilder<RecordingDisposition>(
                                builder: (context, snapShot) {
                                  final duration = snapShot.hasData
                                      ? snapShot.data!.duration
                                      : Duration.zero;
                                  String twoDigit(int n) =>
                                      n.toString().padLeft(2, '0');

                                  final twoDigitMinits = twoDigit(
                                      duration.inMinutes.remainder(60));

                                  final twoDigitSecound = twoDigit(
                                      duration.inSeconds.remainder(60));

                                  if (duration.inSeconds >= 120) {
                                    controller.stopRecording();
                                    setState(() {});
                                  }
                                  return Text(
                                    '$twoDigitMinits:$twoDigitSecound',
                                    style: TextStyle(
                                        color: Colorss.recordertimerColor,
                                        fontSize: 30.sp),
                                  );
                                },
                                stream: controller.recorder.onProgress,
                              ),

                        // Container(
                        //   child: TextField(controller: titleC),
                        // ),
                        controller.recorder.isRecording
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
                        controller.recorder.isRecording == false &&
                                controller.record != null
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
                                      if (controller.player.isPlaying) {
                                        await controller.player.stopPlayer();
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
                                          controller: controller.titleC,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                18),
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
                                                        247, 78, 162, 120),
                                                    fontSize: 12.sp),
                                              ),
                                              onPressed: () async {
                                                await controller
                                                    .uploadButtonFun(context);
                                              }),
                                          TextButton(
                                              child: Text(
                                                "إعادة التسجيل",
                                                style: GoogleFonts.tajawal(
                                                    color: Color(0xff00A4EA),
                                                    fontSize: 12.sp),
                                              ),
                                              onPressed: () async {
                                                Navigator.pop(context);
                                                await controller
                                                    .startRecording();
                                                    setState(() {
                                                      
                                                    });
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
                  : LoadingAnimationWidget.beat(
                      color: Colorss.recorderText, size: 40.sp)),
        ),
      ),
    );
  }
}
