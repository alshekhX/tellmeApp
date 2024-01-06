import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:tell_me/models/User.dart';
import 'package:tell_me/util/const.dart';

class AuthProvider with ChangeNotifier {
  String? token;
  String? userName;
  String? password;
  User? user;
  final Dio dio=TellMeConsts().GetdioX();


  signIN(String userName, String password) async {
    try {
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
      } else if (response.statusCode! > 400 && response.statusCode! < 500) {
        return '400';
      } else {
        return 'e';
      }
    } catch (e) {
      return 's';
    }
  }

  registerUser(String userName, String password) async {
    final url = '/api/v1/auth/register';

    try {
      Response response = await dio.post(url, data: {
        "username": userName,
        "password": password,
      });
      print(response.data);
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

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response = await dio.post('/api/v1/auth/me');
    print(response.data);
    if (response.statusCode == 200) {
      final data = response.data['data'];
      user = User.fromMap(data);
      notifyListeners();
      return 'success';
    } else {
      return 'false';
    }
  }

  checkUserName(String name) async {

    dio.options.headers["authorization"] = 'Bearer $token';
    Response response =
        await dio.post('/api/v1/auth/user', data: {"username": name});
    print(response.data);
    if (response.statusCode == 200) {
      return 'success';
    } else if (response.statusCode == 401) {
      return 'exist';
    } else {
      return 's';
    }
  }
}
