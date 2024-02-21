import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/likesprovider.dart';
import 'package:tell_me/util/const.dart';

import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../classes/colors.dart';

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
  bool hide = false;

  @override
  void initState() {
    player = widget.player;

    plaayRecord();
    player!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        hide = true;
        print(hide);

        setState(() {});
      }
    });

    // TODO: implement initState
    super.initState();
  }

  plaayRecord() async {
    await player!.setUrl(
        // Load a URL
        TellMeConsts.localBaseUrL + "/uploads/audio/${widget.record}",
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
                  content: Text('بطل نرجسية, دا التسجيل بتاعك',
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
                              String internetConn =
                                  await _checkInternetConnection();

                              if (internetConn == 'false') {
                                setState(() {});

                                showTopSnackBar(
                                    context,
                                    CustomSnackBar.error(
                                      message:
                                          "تاكد من تشغيل بيانات الهاتف وحاول مجددا",
                                    ),
                                    displayDuration:
                                        Duration(milliseconds: 1500));
                              } else {
                                hide = false;
                                player!.seek(Duration(seconds: 0));
                                player!.play();
                                setState(() {});
                              }
                            }
                          },
                          child: CircleAvatar(
                            radius: 20.sp,
                            backgroundColor: Colors.grey.shade300,
                            child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18.sp,
                              child: Padding(
                                padding: EdgeInsets.all(2.sp),
                                child: Image.asset(
                                  'assets/images/mic.png',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        (player!.playing == true) && (hide == false)
                            ? SizedBox(
                                height: 32.sp,
                                width: 32.sp,
                                child: Lottie.asset(
                                  'assets/lotti/speakerMain2.json',
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
                                child: Container(
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
                                              color:
                                                  Colors.grey.withOpacity(.6),
                                              width: 1),
                                        ),
                                        labelText: " سبب التبليغ",
                                        labelStyle: GoogleFonts.tajawal(
                                            fontSize: 10.sp,
                                            color: Color(0xffB9B9B9),
                                            fontWeight: FontWeight.w400)),
                                  ),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                    child: Text(
                                      "إرسال",
                                      style: GoogleFonts.tajawal(
                                          color: Colors.red),
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
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 5.sp, top: 2.sp, bottom: 2.sp),
                            child: Image.asset(
                              'assets/images/red_card1.png',
                              height: 18.sp,
                              width: 18.sp,
                            ),
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
                height: 0,
              ))
        ],
      ),
    );
  }

  bool? _isConnected;

  Future<String> _checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
        setState(() {
          _isConnected = true;
        });
        return 'success';
      }
      return 'success';
    } on SocketException catch (err) {
      return 'false';
    }
  }
}
