import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:tell_me/models/QuestionModel.dart';

class QuestionProvider with ChangeNotifier {
  List? questions;
  int? curentIndex;

  Question? question;

  // ignore: unnecessary_new
  BaseOptions options = new BaseOptions(
    baseUrl: "https://aboutmetell.com",
    connectTimeout: 150000,
    receiveTimeout: 150000,
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  getQuestions() async {
    try {
      // String gte = 'gte';
      // String lte = 'lte';

      // //Dio option config

      // var calendarTime = CalendarTime(DateTime.now());

      // var dayBefore = calendarTime.startOfToday.subtract(Duration(days: 1));
      // var dayEnd = calendarTime.endOfToday;

      // print(calendarTime.startOfToday);

      Dio dio = Dio(options);

      // Response response = await dio.get("/api/v1/articles", queryParameters: {
      //   'createdAt': {"$gte": "$dayBefore", "\$$lte": "$dayEnd"}
      // });

      Response response = await dio.get(
        "/api/v1/question",
      );
      print(response.data);
      if (response.statusCode == 200) {
        final map = response.data['data'];

        questions = map.map((i) => Question.fromMap(i)).toList();
        // DateTime
        return 'success';
      } else {
        String error = response.data['errorMessage'].toString();
        return error;
      }
    } catch (e) {
      return e.toString();
    }
  }
}
