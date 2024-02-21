import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'classes/colors.dart';

class Rules extends StatefulWidget {
  const Rules({Key? key}) : super(key: key);

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colorss.recorderBackground),
        title: Text(
          'سياسة الخصوصية',
          style: TextStyle(color: Color(0xff212427)),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            WebView(
              initialUrl: 'https://pages.flycricket.io/tell-me-1/privacy.html',
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
