import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'classes/colors.dart';

class Terms extends StatefulWidget {
  const Terms({Key? key}) : super(key: key);

  @override
  State<Terms> createState() => _TermsState();
}

class _TermsState extends State<Terms> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colorss.recorderBackground),
        title: Text(
          'الشروط والأحكام',
          style: TextStyle(color: Color(0xff212427)),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            WebView(
              initialUrl:
                  'https://www.app-privacy-policy.com/live.php?token=vl39CeR62GnvR836JxiCGMU3rFLu7lUw',
              onPageFinished: (finish) {
                setState(() {
                  isLoading = false;
                });
              },
            ),
            isLoading
                ? Center(
                    child: LoadingAnimationWidget.beat(
                        color: Colorss.recorderBackground, size: 40.sp),
                  )
                : Stack()
          ],
        ),
      ),
    );
  }
}
