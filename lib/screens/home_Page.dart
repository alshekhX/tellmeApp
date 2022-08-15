import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:concentric_transition/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/likesprovider.dart';
import 'package:tell_me/provider/questionProvider.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/recorder_screen.dart';

import '../models/User.dart';
import 'classes/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getlastQuestion();

    // TODO: implement initState
    super.initState();
  }

  final player = AudioPlayer();
  List? questions = [];

  List audioPlayer = [];
  List? records;

  getlastQuestion() async {
    // String token =
    //     await Provider.of<QuestionProvider>(context, listen: false).token!;
    await Provider.of<QuestionProvider>(context, listen: false).getQuestions();
    questions = Provider.of<QuestionProvider>(context, listen: false).questions;
    if (questions!.length >= 1) {
      Provider.of<RecordProvider>(context, listen: false).question =
          questions![questions!.length - 1];
    }
    await Provider.of<RecordProvider>(context, listen: false).getRecords();
    records = Provider.of<RecordProvider>(context, listen: false).records;

    for (int i = 0;
        i <=
            Provider.of<RecordProvider>(context, listen: false).records!.length;
        i++) {
      audioPlayer.add(AudioPlayer());

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<AuthProvider>(context, listen: false).user!;
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTopPop,
                    child: RecorderScreen(),
                    childCurrent: HomePage()));
          },
          child: Icon(
            Icons.mic,
            color: Colorss.homefloatingIcon,
            size: 29,
          ),
          backgroundColor: Colorss.homefloatingbackground,
          tooltip: 'Capture Picture',
          elevation: 5,
          splashColor: Colors.grey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.white,
        body: Container(
          child: questions == null || records == null
              ? Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                      color: Colorss.recorderBackground, size: 40.sp))
              : SingleChildScrollView(
                  child: Column(children: [
                    SizedBox(
                      height: 6.h,
                    ),
                    Card(
                      borderOnForeground: true,
                      color: Colorss.mainCardBackGround,
                      elevation: 5,
                      child: Container(
                        width: 95.w,
                        child: Padding(
                          padding: EdgeInsets.all(7.sp),
                          child: DefaultTextStyle(
                            style: GoogleFonts.tajawal(
                                fontSize: 25.sp, color: Colorss.mainCardtext),
                            child: AnimatedTextKit(
                              totalRepeatCount: 1,
                              animatedTexts: [
                                TypewriterAnimatedText(
                                  questions![questions!.length - 1].title,
                                  speed: Duration(milliseconds: 120),
                                ),
                              ],
                              onTap: () {
                                print("Tap Event");
                              },
                            ),
                          ),

                          //  AutoSizeText(
                          //   'وريني اكتر حاجة مهمة حصلت ليك الاسبوع الفات والسبب الخلاها مهمة شديد ',
                          //   textDirection: TextDirection.rtl,
                          //   style: TextStyle(
                          //     fontSize: 30.sp,
                          //   ),
                          // ),
                        ),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(child: Consumer<RecordProvider>(
                        builder: (context, recordP, _) {
                      if (recordP.records != null && audioPlayer.isNotEmpty) {
                        List<Widget> recordWidgets = [];
                        List records = recordP.records!;

                        for (int i = 0; i < recordP.records!.length; i++) {
                          String type = 'شخص';

                          if (records[i].user == user.id) {
                            type = 'أنت';
                          }
                          recordWidgets.add(
                            AudioListTile(
                              type: type,
                              title: records[i].title,
                              record: records[i].record,
                              player: audioPlayer[i],
                              id: records[i].id,
                            ),
                          );
                        }

                        return Column(
                          children: recordWidgets.reversed.toList(),
                        );
                      } else {
                        return Center(
                            child: LoadingAnimationWidget.staggeredDotsWave(
                                color: Colorss.recorderBackground,
                                size: 20.sp));
                      }
                    }))
                  ]),
                ),
        ),
      ),
    );
  }
}

class AudioListTile extends StatefulWidget {
  final String type;
  final String title;
  final String record;
  final AudioPlayer player;
  final String id;

  const AudioListTile(
      {Key? key,
      required this.type,
      required this.record,
      required this.title,
      required this.id,
      required this.player})
      : super(key: key);

  @override
  State<AudioListTile> createState() => _AudioListTileState();
}

class _AudioListTileState extends State<AudioListTile> {
  AudioPlayer? player;
  bool lotti = true;

  @override
  void initState() {
    player = widget.player;

    plaayRecord();

    // TODO: implement initState
    super.initState();
  }

  plaayRecord() async {
    await player!.setUrl(
        // Load a URL
        "http://192.168.43.250:7000/uploads/audio/${widget.record}",
        preload: false);
    return player;
  }

  @override
  void dispose() {
    player!.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  TextEditingController titleC = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.h),
      child: Column(
        children: [
          InkWell(
            splashColor: Color(0xff836F81).withOpacity(.5),
            onLongPress: () async {
              if (Provider.of<AuthProvider>(context, listen: false)
                      .user!
                      .records!
                      .map((e) => e.id)
                      .toList()
                      .contains(widget.id) ==
                  true) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 2),
                  backgroundColor: Color(0xff836F81),
                  content: Text('بطل نرجسية ي فنان دا التسجيل بتاعك',
                      style: GoogleFonts.tajawal(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400)),
                ));
              } else {
                String token =
                    Provider.of<AuthProvider>(context, listen: false).token!;
                bool res =
                    await Provider.of<LikesProvider>(context, listen: false)
                        .likeRecord(widget.id, token);
                if (res == true) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Color(0xff836F81),
                    content: Text(' لقد قمت بالاعجاب ي لعاب',
                        style: GoogleFonts.tajawal(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400)),
                  ));
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    backgroundColor: Color.fromARGB(255, 200, 1, 18),
                    content: Text("حدث خطأ حزين ي محترم",
                        style: GoogleFonts.tajawal(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w400)),
                  ));
                }
              }
            },
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 5.sp),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        InkWell(
                          onTap: () async {
                            if (player!.playing == true) {
                              player!.stop();
                              setState(() {});
                            } else if (player!.playing == false) {
                              player!.play();
                              setState(() {});
                            }
                          },
                          child: CircleAvatar(
                            radius: 24,
                            backgroundColor: Colors.grey.shade300,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 21,
                              child: Image.asset(
                                'assets/images/microphone2.png',
                                width: 8.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(color: Colorss.dialogtext),
                        ),
                        player!.playing == true
                            ? Container(
                                height: 30.sp,
                                width: 30.sp,
                                child: Lottie.asset(
                                  'assets/lotti/speakerMain.json',
                                  height: 30.sp,
                                  animate: lotti,
                                  width: 30.sp,
                                ),
                              )
                            : Container(),
                        Spacer(),
                        InkWell(
                          onTap: () async {
                            await NAlertDialog(
                              dialogStyle: DialogStyle(titleDivider: false),
                              title: Text(
                                "اكتب سبب التبليغ",
                                style: GoogleFonts.tajawal(
                                    color: Colorss.dialogtext, fontSize: 16.sp),
                              ),
                              content: Form(
                                key: formkey,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'لا تترك هذا الحقل فارغا';
                                    }
                                  },
                                  controller: titleC,
                                  decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 0, horizontal: 2.w),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey.withOpacity(.6),
                                            width: 1),
                                      ),
                                      labelText: '',
                                      labelStyle: GoogleFonts.tajawal(
                                          fontSize: 10.sp,
                                          color: Color(0xffB9B9B9),
                                          fontWeight: FontWeight.w400)),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    child: Text(
                                      "إرسال",
                                      style: GoogleFonts.tajawal(
                                          color: Color.fromARGB(
                                              247, 78, 162, 120)),
                                    ),
                                    onPressed: () async {
                                      if (formkey.currentState!.validate()) {
                                        CustomProgressDialog progressDialog =
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
                                                                .circular(20)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              25),
                                                      child: LoadingAnimationWidget
                                                          .staggeredDotsWave(
                                                              color: Colorss
                                                                  .recorderBackground,
                                                              size: 40.sp),
                                                    )));
                                        progressDialog.show();

                                        String token =
                                            Provider.of<AuthProvider>(context,
                                                    listen: false)
                                                .token!;

                                        String res =
                                            await Provider.of<LikesProvider>(
                                                    context,
                                                    listen: false)
                                                .reportRecord(widget.id,
                                                    titleC.text, token);
                                        progressDialog.dismiss();

                                        print(res);

                                        if (res == 'success') {
                                          Navigator.pop(context);

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 3),
                                            backgroundColor: Color(0xff0288D1),
                                            content: Text('تم رفع البلاغ بنجاح',
                                                style: GoogleFonts.tajawal(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ));
                                        } else {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 4),
                                            backgroundColor:
                                                Color.fromARGB(255, 209, 2, 23),
                                            content: Text(
                                                'حدث خطأ أثناء رفع البلاغ رجاء حاول مجددا',
                                                style: GoogleFonts.tajawal(
                                                    fontSize: 12.sp,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400)),
                                          ));
                                        }
                                      }
                                    }),
                                TextButton(
                                    child: Text(
                                      "إلغاء",
                                      style: GoogleFonts.tajawal(
                                          color: Color(0xff00A4EA)),
                                    ),
                                    onPressed: () async {
                                      Navigator.pop(context);
                                    }),
                              ],
                            ).show(context);
                          },
                          child: Image.asset(
                            'assets/images/red-card.png',
                            height: 15.sp,
                            width: 15.sp,
                          ),
                        ),
                        // Text(
                        //   widget.type,
                        //   style: TextStyle(color: Colors.grey.shade600),
                        // ),
                        SizedBox(width: 10.w),
                      ],
                    ),
                    SizedBox(
                      height: .5.h,
                    ),
                    Container(
                      width: 30.w,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // LikeButton(
                            //   size: 15.sp,
                            //   onTap: (booll) async {
                            //     String token =
                            //         Provider.of<AuthProvider>(context, listen: false)
                            //             .token!;
                            //     if (bool != true)
                            //       return await Provider.of<LikesProvider>(context,
                            //               listen: false)
                            //           .likeRecord(widget.id, token);
                            //     else
                            //       return true;
                            //   },
                            //   circleColor: CircleColor(
                            //       start: Color(0xff00ddff), end: Color(0xff0099cc)),
                            //   bubblesColor: BubblesColor(
                            //     dotPrimaryColor: Color(0xff33b5e5),
                            //     dotSecondaryColor: Color(0xff0099cc),
                            //   ),
                            //   likeBuilder: (bool isLiked) {
                            //     return Icon(
                            //       Ionicons.heart,
                            //       color:
                            //           isLiked ? Colors.deepPurpleAccent : Colors.grey,
                            //       size: 15.sp,
                            //     );
                            //   },
                            // ),
                            // Spacer(),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        //           child: Row(
                        //             crossAxisAlignment: CrossAxisAlignment.center,
                        //             mainAxisSize: MainAxisSize.min,
                        //             mainAxisAlignment: MainAxisAlignment.center,
                        //             children: [

                        //               LikeButton(
                        //                 size: 15.sp,
                        //                 circleColor:
                        //                     CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
                        //                 bubblesColor: BubblesColor(
                        //                   dotPrimaryColor: Color(0xff33b5e5),
                        //                   dotSecondaryColor: Color(0xff0099cc),
                        //                 ),
                        //                 likeBuilder: (bool isLiked) {
                        //                   return Icon(
                        //                     Ionicons.heart,
                        //                     color: isLiked ? Colors.deepPurpleAccent : Colors.grey,
                        //                     size: 15.sp,
                        //                   );
                        //                 },

                        //               ),

                        // Spacer(),

                        //                           Icon(Ionicons.sad,size: 15.sp,color: Colors.red.withOpacity(.3),),
                        //   ],
                        //           ),
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
              width: 80.w,
              child: Divider(
                color: Colors.grey.shade300,
                thickness: 1.5,
                endIndent: 1,
                indent: 1,
              ))
        ],
      ),
    );
  }
}
