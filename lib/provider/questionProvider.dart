import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:tell_me/models/QuestionModel.dart';
import 'package:tell_me/util/const.dart';

class QuestionProvider with ChangeNotifier {
  List? questions;
  int? curentIndex;

  Question? question;
  final Dio dio = TellMeConsts().GetdioX();

  // ignore: unnecessary_new

  getQuestions() async {
    try {
      // String gte = 'gte';
      // String lte = 'lte';

      // //Dio option config

      // var calendarTime = CalendarTime(DateTime.now());

      // var dayBefore = calendarTime.startOfToday.subtract(Duration(days: 1));
      // var dayEnd = calendarTime.endOfToday;

      // print(calendarTime.startOfToday);

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
        notifyListeners();
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
