import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'classes/colors.dart';

class Rules extends StatefulWidget {
  const Rules({ Key? key }) : super(key: key);

  @override
  State<Rules> createState() => _RulesState();
}

class _RulesState extends State<Rules> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colorss.recorderBackground),
        title: Text(
          'سياية الخصوصية',
          style: TextStyle(color: Color(0xff212427)),
        ),
      ),
      body: Container(
        
        child:   WebView(
         initialUrl: 'https://pages.flycricket.io/tell-me-1/privacy.html',
             ),
        
      ),
    );
  }
}