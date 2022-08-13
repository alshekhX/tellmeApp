import 'dart:io';
import 'dart:typed_data';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:lottie/lottie.dart';
import 'package:tell_me/models/RecordModel.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/classes/colors.dart';
import 'package:tell_me/screens/home_Page.dart';

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

  updateUserNotification() async {
    // String token =
    //     await Provider.of<QuestionProvider>(context, listen: false).token!;
    await Provider.of<AuthProvider>(context, listen: false).getUserData();
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
    return Scaffold(
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
                                List<FocusedMenuItem> likesWidget = likes
                                    .map(
                                      (e) => FocusedMenuItem(
                                          title: Text(
                                            '  ${e.likes.toString()} إعجاب في تسجيل ${e.title!}',
                                            style: TextStyle(fontSize: 11.sp),
                                          ),
                                          trailingIcon: Icon(
                                              Ionicons.heart_circle,
                                              color: Color(0xff836F81)),
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
                                return FocusedMenuHolder(
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
                                          color: Colorss.recordertimerColor,
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
                      height: 20.h,
                    ),
                    Container(
                      height: 22.h,
                      width: 22.h,
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
                                      child: Lottie.asset(
                                          'assets/lotti/speakerRecorder.json',
                                          height: 200.sp,
                                          width: 200.sp,
                                          animate: value.lottiAnime),
                                    );
                                  }),
                                )
                              : recorder.isRecording
                                  ? Icon(
                                      Icons.stop,
                                      color: Colorss.recorderfloatingIcon,
                                      size: 100.sp,
                                    )
                                  : Image.asset(
                                      'assets/images/microphone3.png',
                                      height: 100.sp,
                                    )

                          // Icon(
                          //     Icons.mic,
                          //     color: Colorss.recorderfloatingIcon,
                          //     size: 100.sp,
                          //   )

                          ),
                    ),
                    SizedBox(
                      height: 2.h,
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
                                  thumbColor: Color.fromARGB(186, 242, 151, 47),
                                  progressBarColor: Color(0xffF2962F),
                                  baseBarColor:
                                      Color(0xffF2962F).withOpacity(.7),
                                  progress: progress,
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
                                    fontSize: 25.sp),
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
                            fit: BoxFit.fill,
                          )
                        : Container(),
                    Spacer(),
                    recorder.isRecording == false && record != null
                        ? Container(
                            width: 30.w,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  primary: Colorss.recordertimerColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                    side: BorderSide(
                                        width: 1.0, color: Colors.white),
                                  ),
                                ),
                                onPressed: () async {
                                  await NAlertDialog(
                                    dialogStyle:
                                        DialogStyle(titleDivider: true),
                                    title: Text(
                                      "اكتب عنونا للتسجيل",
                                      style:
                                          TextStyle(color: Colorss.dialogtext),
                                    ),
                                    content: TextField(
                                      controller: titleC,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 0, horizontal: 2.w),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color:
                                                    Colors.grey.withOpacity(.6),
                                                width: 1),
                                          ),
                                          labelText: 'العنوان',
                                          labelStyle: TextStyle(
                                              fontSize: 10.sp,
                                              color: Color(0xffB9B9B9),
                                              fontWeight: FontWeight.w400)),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                          child: Text(
                                            "إرسال التسجيل",
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    247, 78, 162, 120)),
                                          ),
                                          onPressed: () async {
                                            CustomProgressDialog
                                                progressDialog =
                                                CustomProgressDialog(context,
                                                    blur: 30,
                                                    loadingWidget: Container(
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
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
                                                                  size: 40.sp),
                                                        )));
                                            progressDialog.show();

                                            String token =
                                                Provider.of<AuthProvider>(
                                                        context,
                                                        listen: false)
                                                    .token!;

                                            String res = await Provider.of<
                                                        RecordProvider>(context,
                                                    listen: false)
                                                .createRecord(
                                                    titleC.text, record, token);
                                            progressDialog.dismiss();

                                            print(res);

                                            if (res == 'success') {
                                              Navigator.pop(context);

                                              alertDialog('تمت العملية',
                                                  "تم رفع تسجيلك بنجاح ", true);
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
                                            style: TextStyle(
                                                color: Color(0xff00A4EA)),
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
                                      fontSize: 15.sp),
                                )),
                          )
                        : Container(),
                    SizedBox(
                      height: 3.h,
                    )
                  ],
                )
              : CircularProgressIndicator(
                  color: Colorss.recordertext,
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
        bitRate: 128000);
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
      recorder.setSubscriptionDuration(Duration(milliseconds: 500));
      player.setSubscriptionDuration(Duration(milliseconds: 100));
    }
  }

  alertDialog(String title, String message, bool menu) {
    return NAlertDialog(
      dialogStyle: DialogStyle(titleDivider: true),
      title: Text(title,
          style: TextStyle(
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
              style: TextStyle(color: Color(0xff00A4EA)),
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        menu == true
            ? TextButton(
                child: Text(
                  "الذهاب إلى القائمة",
                  style: TextStyle(color: Color(0xff00A4EA)),
                ),
                onPressed: () {
                  Navigator.push(
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
}
