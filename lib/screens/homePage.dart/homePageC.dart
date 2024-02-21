import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/models/User.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/questionProvider.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/homePage.dart/widgets/MAinListShimmer.dart';
import 'package:tell_me/screens/homePage.dart/widgets/MainListTitle.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class HomePageController {
  GlobalKey cardKey = GlobalKey();
  GlobalKey floatingbuttonkey = GlobalKey();
  GlobalKey listKey = GlobalKey();
  // GlobalKey keyButton3 = GlobalKey();
  // GlobalKey keyButton4 = GlobalKey();
  // GlobalKey keyButton5 = GlobalKey();

  final player = AudioPlayer();
  List? questions = [];
  int? currentIndex = 0;
  List audioPlayer = [];
  int pageNumber = 1;
  List? records;
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  HomePageController() {}

  getlastQuestion(BuildContext context) async {
    await Provider.of<AuthProvider>(context, listen: false).getUserData();

    // String token =
    //     await Provider.of<QuestionProvider>(context, listen: false).token!;
    await Provider.of<QuestionProvider>(context, listen: false).getQuestions();
    currentIndex =
        Provider.of<QuestionProvider>(context, listen: false).curentIndex ==
                null
            ? 0
            : Provider.of<QuestionProvider>(context, listen: false).curentIndex;
    questions = Provider.of<QuestionProvider>(context, listen: false).questions;

    // ignore: prefer_conditional_assignment

    Provider.of<RecordProvider>(context, listen: false).question =
        questions![currentIndex!];

    await getRecords(context);

    // createTutorial();
    // showTutorial();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('homeT') == null) {
      createTutorial();
      showTutorial(context);
      prefs.setInt('homeT', 1);
    } else if (prefs.getInt('homeT') == 1) {
      createTutorial();
      showTutorial(context);
      prefs.setInt('homeT', 2);
    } else if (prefs.getInt('homeT') == 2) {}
  }

  Future<void> getRecords(BuildContext context) async {
    await Provider.of<RecordProvider>(context, listen: false).getRecords(1);
    records = Provider.of<RecordProvider>(context, listen: false).records;
    audioPlayer.clear();
    print(records);

    for (int i = 0; i < records!.length; i++) {
      audioPlayer.add(AudioPlayer());
    }
  }

  updateQuestion(BuildContext context) async {
    questions = Provider.of<QuestionProvider>(context, listen: false).questions;

    // ignore: prefer_conditional_assignment
    // setState(() {});
    print(questions!.length);
    print(currentIndex);
                currentIndex = currentIndex! + 1;

    if (questions!.length-1 < currentIndex!) {
      currentIndex = 0;
    }

    Provider.of<RecordProvider>(context, listen: false).question =
          questions![currentIndex!];
  
  

    await Provider.of<RecordProvider>(context, listen: false).getRecords(1);
    records = Provider.of<RecordProvider>(context, listen: false).records;
    audioPlayer.clear();

    for (int i = 0; i <= records!.length; i++) {
      audioPlayer.add(AudioPlayer());

      // setState(() {});
    }
    pageNumber = 1;
    // setState(() {});
  }



  void dispose() {
    // tutorialCoachMark!.skip();
    cardKey.currentState!.deactivate();
    listKey.currentState!.deactivate();
    floatingbuttonkey.currentState!.deactivate();
  }

  onRefresh(BuildContext context) async {
    await updateQuestion(context);
    refreshController.refreshCompleted();
  }

  onLoading(BuildContext context) async {
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

      // setState(() {});
    }

    // if failed,use loadFailed(),if no data return,use LoadNodata()
    refreshController.loadComplete();
  }

  void showTutorial(BuildContext context) {
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
    );
  }

//targets

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        enableOverlayTab: true,
        targetPosition: TargetPosition(Size(70.w, 10.h), Offset(15.w, 10.h)),
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
        targetPosition: TargetPosition(Size(70.w, 10.h), Offset(40.w, 45.h)),
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
        targetPosition: TargetPosition(Size(70.w, 10.h), Offset(20.w, 45.h)),
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
        targetPosition: TargetPosition(Size(75.w, 10.h), Offset(-10.w, 45.h)),
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
                    SizedBox(
                      height: 1.h,
                    ),
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



//consumer method
  Widget consumerMetod(RecordProvider recordP, User user,bool shimmer) {
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
    
          if (records![i].user ==
              user.id) {
            type = 'أنت';
          }
    
          recordWidgets.add(
            AudioListTile(
              type: type,
              title: records![i].title ==
                      null
                  ? ''
                  : records![i].title,
              record:
                  records![i].record,
              player: audioPlayer[i],
              id: records![i].id,
              // name:records![i].title[0],
            ),
          );
        }
        if (recordWidgets.isEmpty) {
          return Center(
            child: Column(children: [
              Container(
                width: 100.sp,
                child: LottieBuilder.asset(
                    'assets/lotti/first.json'),
              ),
              Text(
                'كن أول تسجيل لهذا السؤال',
                style: GoogleFonts.tajawal(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold),
              )
            ]),
          );
        } else
          return Column(
            children: recordWidgets,
          );
      } else if (records != null) {
        if (records!.isEmpty) {}
    
        return Center(
          child: Column(children: [
            Container(
              width: 100.sp,
              child: LottieBuilder.asset(
                  'assets/lotti/first.json'),
            ),
            Text(
              'كن أول تسجيل لهذا السؤال',
              style: GoogleFonts.tajawal(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold),
            )
          ]),
        );
      }
      return Container();
    }
                                  
  }







}
