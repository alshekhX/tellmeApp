import 'dart:convert';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:tell_me/models/User.dart';

class AuthProvider with ChangeNotifier {
  String? token;
  String? userName;
  String? password;
  User? user;

  // ignore: unnecessary_new
  BaseOptions options = new BaseOptions(
    baseUrl: "http://192.168.43.250:7000",
    connectTimeout: 12000,
    receiveTimeout: 12000,
    contentType: 'application/json',
    validateStatus: (status) {
      return status! < 600;
    },
  );

  signIN(String userName, String password) async {
    try {
      var dio = Dio(options);
      final url = '/api/v1/auth/login';

      print({
        "username": user,
        "password": password,
      });
      Response response = await dio.post(url, data: {
        "username": userName,
        "password": password,
      });
      print(response.statusCode);
      if (response.statusCode == 200) {
        token = response.data['token'];
        print(token);

        await getUserData();
        return 'success';
      } else {
        return response.data["errorMessage"].toString();
      }
    } catch (e) {
      return e.toString();
    }
  }

  registerUser(String userName, String password) async {
    var dio = Dio(options);
    final url = '/api/v1/auth/register';

    try {
      Response response = await dio.post(url, data: {
        "username": userName,
        "password": password,
      });
      if (response.statusCode == 201) {
        token = response.data['token'];
        print(token);

        await getUserData();
        return "success";
      } else {
        return response.data["errorMessage"].toString();
      }
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  getUserData() async {
    Dio dio = Dio(options);

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/auth/me');
    if (response.statusCode == 200) {
      final data = response.data['data'];
      user = User.fromMap(data);
      notifyListeners();
      return 'success';
    } else {
      return 'false';
    }
  }
}
