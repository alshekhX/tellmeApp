import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:concentric_transition/page_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:lottie/lottie.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/models/RecordModel.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/likesprovider.dart';
import 'package:tell_me/provider/questionProvider.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/recorder_screen.dart';
import 'package:tell_me/screens/widgets/MAinListShimmer.dart';
import 'package:tell_me/screens/widgets/MainListTitle.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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

  GlobalKey cardKey = GlobalKey();
  GlobalKey floatingbuttonkey = GlobalKey();
  GlobalKey listKey = GlobalKey();
  // GlobalKey keyButton3 = GlobalKey();
  // GlobalKey keyButton4 = GlobalKey();
  // GlobalKey keyButton5 = GlobalKey();

  final player = AudioPlayer();
  List? questions = [];
  int? currentIndex;
  List audioPlayer = [];
  int pageNumber = 1;
  List? records;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool shimmer = false;

  getlastQuestion() async {
    await Provider.of<AuthProvider>(context, listen: false).getUserData();

    // String token =
    //     await Provider.of<QuestionProvider>(context, listen: false).token!;
    await Provider.of<QuestionProvider>(context, listen: false).getQuestions();
    currentIndex =
        Provider.of<QuestionProvider>(context, listen: false).curentIndex ==
                null
            ? Provider.of<QuestionProvider>(context, listen: false)
                    .questions!
                    .length -
                1
            : Provider.of<QuestionProvider>(context, listen: false).curentIndex;
    questions = Provider.of<QuestionProvider>(context, listen: false).questions;

    // ignore: prefer_conditional_assignment

    Provider.of<RecordProvider>(context, listen: false).question =
        questions![currentIndex!];
    setState(() {}); // do something else

    await Provider.of<RecordProvider>(context, listen: false).getRecords(1);
    records = Provider.of<RecordProvider>(context, listen: false).records;
    audioPlayer.clear();

    for (int i = 0; i < records!.length; i++) {
      audioPlayer.add(AudioPlayer());
    }

    setState(() {
      
    });

    // createTutorial();
    // showTutorial();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('homeT') == null) {
      createTutorial();
      showTutorial();
      prefs.setInt('homeT', 1);
    }
    else if(prefs.getInt('homeT')==1){

 createTutorial();
      showTutorial();
      prefs.setInt('homeT', 2);

    }
    else if(prefs.getInt('homeT')==2){

    }
  }

  updateQuestion() async {
    questions = Provider.of<QuestionProvider>(context, listen: false).questions;

    print(questions!.length);
    // ignore: prefer_conditional_assignment
    shimmer = true;
    setState(() {});

    if (questions!.length >= 3) {
      if (currentIndex ==
          Provider.of<QuestionProvider>(context, listen: false)
                  .questions!
                  .length -
              1) {
        print('first');
        currentIndex = Provider.of<QuestionProvider>(context, listen: false)
                .questions!
                .length -
            2;
        Provider.of<RecordProvider>(context, listen: false).question =
            questions![currentIndex!];
        setState(() {});
      } else if (
          // do something

          currentIndex ==
              Provider.of<QuestionProvider>(context, listen: false)
                      .questions!
                      .length -
                  2) {
        print('secound');

        currentIndex = Provider.of<QuestionProvider>(context, listen: false)
                .questions!
                .length -
            3;
        Provider.of<RecordProvider>(context, listen: false).question =
            questions![currentIndex!];
        setState(() {}); // do something else
      } else if (
          // do something

          currentIndex ==
              Provider.of<QuestionProvider>(context, listen: false)
                      .questions!
                      .length -
                  3) {
        print('third');

        currentIndex = Provider.of<QuestionProvider>(context, listen: false)
                .questions!
                .length -
            1;
        Provider.of<RecordProvider>(context, listen: false).question =
            questions![currentIndex!];
        setState(() {}); // do something else
      }
    }
    // Provider.of<RecordProvider>(context, listen: false).question =
    //     questions![questions!.length - 1];

    print(currentIndex);
    await Provider.of<RecordProvider>(context, listen: false).getRecords(1);
    records = Provider.of<RecordProvider>(context, listen: false).records;
    audioPlayer.clear();

    for (int i = 0; i <= records!.length; i++) {
      audioPlayer.add(AudioPlayer());

      setState(() {});
    }
    shimmer = false;
    setState(() {});
  }

  @override
  void dispose() {
    tutorialCoachMark!.skip();
    cardKey.currentState!.deactivate();
    listKey.currentState!.deactivate();
    floatingbuttonkey.currentState!.deactivate();

    super.dispose();
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
          key: floatingbuttonkey,
          onPressed: () async {
            Provider.of<QuestionProvider>(context, listen: false).curentIndex =
                currentIndex;
            print(Provider.of<RecordProvider>(context, listen: false)
                .question!
                .id);
            await Navigator.pushReplacement(
                context,
                PageTransition(
                    type: PageTransitionType.bottomToTop,
                    child: const RecorderScreen(),
                    childCurrent: const HomePage()));
          },
          child: Icon(
            Ionicons.mic,
            color: Colorss.homefloatingIcon,
            size: 29,
          ),
          backgroundColor: Colorss.homefloatingbackground,
          tooltip: 'سجل مقطع صوتي',
          elevation: 5,
          splashColor: Colors.grey,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
            color: Colors.white70,
            child: questions == null || records == null
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colorss.recorderBackground, size: 40.sp))
                : SmartRefresher(
                    onLoading: _onLoading,
                    onRefresh: _onRefresh,
                    enablePullUp: true,
                    footer: ClassicFooter(
                      loadingIcon: LoadingAnimationWidget.discreteCircle(
                          color: Color(0xff0288D1), size: 15.sp),
                      canLoadingText: 'جاري تحميل تسجيلات إضافية',
                      loadingText: "جاري التحميل",
                      noDataText: 'لا توجد تسجيلات إضافية',
                    ),
                    enablePullDown: true,
                    header: MaterialClassicHeader(
                        color: Colorss.recorderBackground),
                    controller: _refreshController,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(
                        ),
                        Card(
                          borderOnForeground: true,
                          color: Colorss.mainCardBackGround,
                          elevation: 5,
                          child: Container(
                            key: cardKey,
                            width: 95.w,
                            child: Padding(
                                padding: EdgeInsets.all(7.sp),
                                child: Text(
                                  questions![currentIndex!].title,
                                  style: GoogleFonts.tajawal(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colorss.mainCardtext),
                                )
        
                                //  DefaultTextStyle(
                                //   style: GoogleFonts.tajawal(
                                //       fontSize: 25.sp,
                                //       color: Colorss.mainCardtext),
                                //   child: AnimatedTextKit(
                                //     totalRepeatCount: 1,
                                //     animatedTexts: [
                                //       TypewriterAnimatedText(
                                //         questions![currentIndex!].title,
                                //         speed: Duration(milliseconds: 110),
                                //       ),
                                //     ],
                                //     onTap: () {
                                //       print("Tap Event");
                                //     },
                                //   ),
                                // ),
        
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
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                            child: Consumer<RecordProvider>(
                                key: listKey,
                                builder: (context, recordP, _) {
                                  if (shimmer == true)
                                    // ignore: curly_braces_in_flow_control_structures
                                    return Column(
                                        children: List.generate(
                                            3, ((index) => MainLisShimmer())));
                                  else {
                                    if (recordP.records != null &&
                                        audioPlayer.isNotEmpty) {
                                      List<Widget> recordWidgets = [];
                                 
        
                                      for (int i = 0;
                                          i < records!.length;
                                          i++) {
                                        String type = 'شخص';
        
                                        if (records![i].user == user.id) {
                                          type = 'أنت';
                                        }
                                        var r = Random();
        String letter= String.fromCharCodes(List.generate(1, (index) => r.nextInt(33) + 89));
                                        recordWidgets.add(
                                          AudioListTile(
                                            type: type,
                                            title: records![i].title==null?'':records![i].title,
                                            record: records![i].record,
                                            player: audioPlayer[i],
                                            id: records![i].id,
                                            // name:records![i].title[0],
                                          ),
                                        );
                                      }
        
                                      return Column(
                                        children: recordWidgets,
                                      );
                                    } else {
                                      return Center(
                                          child: Container());
                                    }
                                  }
                                }))
                      ]),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _onRefresh() async {
    await updateQuestion();
    if (mounted) setState(() {});
    setState(() {});
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    pageNumber++;
    // monitor network fetch
    await Provider.of<RecordProvider>(context, listen: false)
        .getRecords(pageNumber);
    records!
        .addAll(Provider.of<RecordProvider>(context, listen: false).records!);

    print(records);
    for (int i = 0;
        i <=
            Provider.of<RecordProvider>(context, listen: false).records!.length;
        i++) {
      audioPlayer.add(AudioPlayer());

      setState(() {});
    }

    if (Provider.of<RecordProvider>(context, listen: false).records!.isEmpty) {
      _refreshController.loadNoData();
    } else {
      // if failed,use loadFailed(),if no data return,use LoadNodata()
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }
  }

  void showTutorial() {
    tutorialCoachMark!.show(context: context, rootOverlay: false);
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
      },
      onClickTargetWithTapPosition: (target, tapDetails) {
        print("target: $target");
        print(
            "clicked at position local: ${tapDetails.localPosition} - global: ${tapDetails.globalPosition}");
      },
      onClickOverlay: (target) {
        print('onClickOverlay: $target');
      },
      onSkip: () {
        print("skip");
      },
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        keyTarget: cardKey,
        alignSkip: Alignment.bottomLeft,
        contents: [
          TargetContent(
            customPosition: CustomTargetContentPosition(bottom: 5, right: 10),
            builder: (context, controller) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Container(
                  child: Text(
                    "إسحب للأسفل لتغير السؤال",
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
        keyTarget: floatingbuttonkey,
        alignSkip: Alignment.topLeft,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "إضغط هنا لتسجيل إجابتك",
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
        targetPosition: TargetPosition(Size(70.w, 10.h) ,Offset(40.w, 45.h)),
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
              padding: EdgeInsets.all(20),
              align: ContentAlign.bottom,
              child: Container(
                padding: EdgeInsets.only(top: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "إضغط في الصورة لسماع تسجيل مستخدم آخر ",
                      style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.grey.shade300,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 21,
                        child: Image.asset(
                          'assets/images/mic.png',
                          width: 10.w,
                        ),
                      ),
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
        targetPosition: TargetPosition(Size(70.w, 10.h) ,Offset(20.w, 45.h)),
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
              padding: EdgeInsets.all(20),
              align: ContentAlign.bottom,
              child: Container(
                padding: EdgeInsets.only(top: 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "إضغط مطولا في التسجيل لعمل إعجاب",
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
        targetPosition: TargetPosition(Size(75.w, 10.h) ,Offset(-10.w, 45.h)),
        alignSkip: Alignment.topRight,
        contents: [
          TargetContent(
              padding: EdgeInsets.all(20),
              align: ContentAlign.bottom,
              child: Container(
                padding: EdgeInsets.only(top: 22.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "إضغط في الكرت الأحمر لعمل بلاغ ",
                      style: GoogleFonts.tajawal(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp),
                    ),
                    SizedBox(height: 1.h,),
                    Image.asset(
                            'assets/images/red_card1.png',
                            height: 20.sp,
                            width: 20.sp,
                          ),
                  ],
                ),
              )),
        ],
      ),
    );

    return targets;
  }
}
