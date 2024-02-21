
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:tell_me/models/QuestionModel.dart';
import 'package:http_parser/http_parser.dart';

import 'package:tell_me/models/RecordModel.dart';
import 'package:tell_me/util/const.dart';

class RecordProvider with ChangeNotifier {
  List? records;

  Question? question;
  bool lottiAnime = true;

  lootti(bool value) {
    lottiAnime = value;
    notifyListeners();
  }
  final Dio dio=TellMeConsts().GetdioX();


  getRecords(int i) async {
    

    Response response = await dio.get("/api/v1/record",
        queryParameters: {"page": i, "question": question!.id});
    if (response.statusCode == 200) {
      final map = response.data['data'];

      records = map.map((i) => Record.fromMap(i)).toList();
      notifyListeners();
      // DateTime
      return 'success';
    } else {
      String error = response.data['errorMessage'].toString();
      return error;
    }
    // } catch (e) {
    //   return e.toString();
    // }
  }

  createRecord(String title, dynamic record, String token) async {
    // try {
    dio.options.headers["authorization"] = 'Bearer $token';

    print(question!.id);
    FormData formData = FormData.fromMap({
      "recordFile": MultipartFile.fromBytes(record,
          contentType: MediaType('audio', 'mp4'), filename: 'ghvgv'),
      "title": title,
    });

    Response response = await dio.post('/api/v1/record/${question!.id}', data: formData);
    print(response.data);
    if (response.statusCode == 201) {
      await getRecords(1);
      return 'success';
    } else {
      return response.data["errorMessage"].toString();
    }
    // } catch (e) {
    //   return e.toString();
    // }
  }
}
