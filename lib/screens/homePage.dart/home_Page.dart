import 'dart:ui';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:tell_me/provider/auth.dart';
import 'package:tell_me/provider/questionProvider.dart';
import 'package:tell_me/provider/recordsProvider.dart';
import 'package:tell_me/screens/homePage.dart/homePageC.dart';
import 'package:tell_me/screens/recorderScreen/recorder_screen.dart';

import '../../models/User.dart';
import '../classes/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool shimmer = false;
  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  late HomePageController controller;
  @override
  void initState() {
    controller = HomePageController();
    getlastQuestion();
    // TODO: implement initState
    super.initState();
  }

  getlastQuestion() async {
    await controller.getlastQuestion(context);
    setState(() {});
  }

  lottiDidplay() async {
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {});
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
          key: controller.floatingbuttonkey,
          onPressed: () async {
            Provider.of<QuestionProvider>(context, listen: false).curentIndex =
                controller.currentIndex;
            print(Provider.of<RecordProvider>(context, listen: false)
                .question!
                .id);
Beamer.of(context).beamToNamed('/recorder');

            // await Navigator.pushReplacement(
            //     context,
            //     PageTransition(
            //         type: PageTransitionType.bottomToTop,
            //         child: const RecorderScreen(),
            //         childCurrent: const HomePage()));
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
            child: controller.questions == null || controller.records == null
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                        color: Colorss.recorderBackground, size: 40.sp))
                : SmartRefresher(
                    onLoading: () async {
                      await controller.onLoading(context);

                      setState(() {});
                    },
                    onRefresh: () async {
                      shimmer = true;
                      setState(() {});
                      await controller.onRefresh(context);
                      shimmer = false;

                      setState(() {});
                    },
                    enablePullUp: true,
                    footer: ClassicFooter(
                      loadingIcon: LoadingAnimationWidget.threeArchedCircle(
                          color: Colorss.recorderBackground, size: 20.sp),
                      canLoadingText: '',
                      loadingText: "جاري التحميل",
                      noDataText: '',
                      idleText: 'إسحب لأعلى',
                    ),
                    enablePullDown: true,
                    header: MaterialClassicHeader(
                        color: Colorss.recorderBackground),
                    controller: controller.refreshController,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Container(),
                        Card(
                          borderOnForeground: true,
                          color: Colorss().mainCardBackGround,
                          elevation: 4,
                          child: Container(
                            key: controller.cardKey,
                            width: 95.w,
                            child: Padding(
                                padding: EdgeInsets.all(7.sp),
                                child: Text(
                                  controller
                                      .questions![controller.currentIndex!]
                                      .title,
                                  style: GoogleFonts.tajawal(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colorss.mainCardtext),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        Container(
                            child: Consumer2<RecordProvider, QuestionProvider>(
                                key: controller.listKey,
                                builder: (context, recordP, questionP, _) {
                                  return controller.consumerMetod(recordP, user,shimmer);
                                }))
                      ]),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

}
