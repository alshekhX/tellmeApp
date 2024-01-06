import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sizer/sizer.dart';

class TellMeConsts {
  // ignore: non_constant_identifier_names
    static String localBaseUrL =  "http://192.168.235.52:7000/";

  static String NetworkBaseUrL =  "https://aboutmetell.com";
  static String BasePicUrl = 'http://192.168.118.52:8000/uploads/photos/';

  BaseOptions option = BaseOptions(
    baseUrl: localBaseUrL,
    connectTimeout: Duration(seconds: 8) ,
    receiveTimeout:  Duration(seconds: 8),
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  GetdioX() {
    return Dio(option);
  }

  final double pagePadding = 6.w;
    final double headLinePadding = 5.w;
        final double bottomNavText = 18;
        

  Future<String> checkInternetConnection() async {
    try {
      final response = await InternetAddress.lookup('www.google.com');
      if (response.isNotEmpty) {
       
        return 'success';
      }
      return 'success';
    } on SocketException catch (err) {
      return 'false';
    }
  }



}

