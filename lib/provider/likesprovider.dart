import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:tell_me/models/QuestionModel.dart';
 import 'package:http_parser/http_parser.dart';

import 'package:tell_me/models/RecordModel.dart';

class LikesProvider with ChangeNotifier {
  List? likes;

  Question? question;

  // lootti(bool value) {
  //   lottiAnime = value;
  //   notifyListeners();
  // }

  // ignore: unnecessary_new
  BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.43.250:7000",
    connectTimeout: 150000,
    receiveTimeout: 150000,
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  // getRecords() async {
  //   // try {
  //     // String gte = 'gte';
  //     // String lte = 'lte';

  //     // //Dio option config

  //     // var calendarTime = CalendarTime(DateTime.now());

  //     // var dayBefore = calendarTime.startOfToday.subtract(Duration(days: 1));
  //     // var dayEnd = calendarTime.endOfToday;

  //     // print(calendarTime.startOfToday);

  //     Dio dio = Dio(options);

  //     // Response response = await dio.get("/api/v1/articles", queryParameters: {
  //     //   'createdAt': {"$gte": "$dayBefore", "\$$lte": "$dayEnd"}
  //     // });

  //     Response response = await dio.get(
  //       "/api/v1/record/${question!.id}",
  //     );
  //     print(response.data);
  //     if (response.statusCode == 200) {
  //       final map = response.data['data'];

  //       records = map.map((i) => Record.fromMap(i)).toList();
  //       notifyListeners();
  //       // DateTime
  //       return 'success';
  //     } else {
  //       String error = response.data['errorMessage'].toString();
  //       return error;
  //     }
  //   // } catch (e) {
  //   //   return e.toString();
  //   // }
  // }

  likeRecord(String recordId, String token) async {
    // try {
    var dio = Dio(options);
    dio.options.headers["authorization"] = 'Bearer $token';

    String url = '/api/v1/like/$recordId';
   

    Response response = await dio.post(url);
    print(response.data);
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
    // } catch (e) {
    //   return e.toString();
    // }
  }

   reportRecord(String recordId,String title, String token) async {
    // try {
    var dio = Dio(options);
    dio.options.headers["authorization"] = 'Bearer $token';

    String url = '/api/v1/report';
   

    Response response = await dio.post(url,data: {"record":recordId,"title":title});
    print(response.data);
    if (response.statusCode == 201) {
      return 'success';
    } else {
      return 'failure';
    }
    // } catch (e) {
    //   return e.toString();
    // }
  }
}
