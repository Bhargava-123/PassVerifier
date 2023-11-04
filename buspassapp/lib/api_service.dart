import 'dart:async';
import 'dart:convert';
import 'package:buspassapp/Controller.dart';
import 'package:buspassapp/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Map<String, String> headers = {'Content-Type': 'application/json'};

String baseUrl = "http://127.0.0.1:8000/api";
final controller = Get.put(ControllerPage());
final ControllerPage ctrl = Get.find();

class PassService {
  String bioId;
  PassService({required this.bioId});
  Future<List<dynamic>> getDetails() async {
    // debugPrint(ctrl.authToken);
    final response = await http.get(
        Uri.parse("$baseUrl/get-pass-details/$bioId/"),
        headers: <String, String>{
          'Content-Type': "application/json",
          'Authorization': ctrl.authToken
        });
    // debugPrint(response.body.runtimeType.toString());
    if (response.statusCode != 200) {
      return Future.value([
        {'Error': "False"}
      ]);
    }
    return Future.value(jsonDecode(response.body));
  }
}

class getScanLogService {
  String date;
  getScanLogService({required this.date});
  Future<List<dynamic>> getDetails() async {
    // debugPrint(ctrl.authToken);
    final response = await http.get(Uri.parse("$baseUrl/get-scan-log/$date/"),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': ctrl.authToken
        });
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return Future.value(responseJson);
    } else {
      failedSnack("Failed", "Failed to load Data");
      return Future.value([]);
    }
  }
}

class AuthenticateService {
  String username;
  String password;
  AuthenticateService({required this.username, required this.password});
  Future<String> getDetails() async {
    // print(password);
    // print(username);
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: headers,
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    //after submitting response

    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);
      // successSnack("Successful Login","");
      // debugPrint(responseJson['access']);
      controller.setToken(responseJson['access_token']);
      final SharedPreferences prefs = await _prefs;
      prefs.setString("access", ctrl.authToken);
      debugPrint(prefs.getString("access"));
      Get.to(const Home());
    } else {
      failedSnack("Failed", "Wrong Password or Username");
    }
    return response.body;
  }
}

class PostScanLogService {
  String date = DateFormat("d-MM-yyyy").format(DateTime.now());
  String time = DateFormat("HH:mm:ss").format(DateTime.now());
  String bioId;
  String studentName;
  PostScanLogService({required this.bioId, required this.studentName});
  Future<String> postScanLog() async {
    debugPrint(ctrl.authToken);
    var response = await http.post(
      Uri.parse('$baseUrl/post-scan-log/$date/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': ctrl.authToken,
      },
      body: jsonEncode({
        "scan_date": date,
        "scan_time": time,
        "bio_id": bioId,
        "student_name": studentName,
      }),
    );
    // print(response.body.toString());
    return response.body;
  }
}

Future<bool> checkTokenValidity(String? accessToken) async {
  final response = await http.post(Uri.parse("$baseUrl/check-access-token/"),
      headers: headers, body: jsonEncode({'access': accessToken}));
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

class CheckAccessTokenService {
  final Future<SharedPreferences> myprefs = SharedPreferences.getInstance();
  late String? accessToken;
  CheckAccessTokenService();
  Future<bool> checkAccessToken() async {
    SharedPreferences pref = await myprefs;
    // String = pref.getString("access").toString();

    if (pref.getString("access") != null) {
      // checkTokenValidity()
      bool isTokenValid = await Future.value(
          checkTokenValidity(pref.getString('access')!.substring(
                7,
              )));
      if (isTokenValid) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }

    // if (pref.containsKey("access")) {
    //   accessToken = pref.getString("access");
    //   if (accessToken == null) {
    //     accessToken = "";
    //   } else {
    //     accessToken = accessToken!.substring(7, accessToken!.length);
    //   }
    //   debugPrint(accessToken);
    //   return true;
    // } else {
    //   debugPrint("asdfasdsssssssssssssssssss");
    //   debugPrint(accessToken);
    //   return false;
    // }
  }
}

class LogOutService {
  LogOutService();
  void logOut() async {
    Future<SharedPreferences> myprefs = SharedPreferences.getInstance();
    SharedPreferences pref = await myprefs;
    String? accessToken = pref.getString('access');
    accessToken = accessToken!.substring(7);
    final response = await http.post(Uri.parse("$baseUrl/logout/"),
        headers: headers, body: jsonEncode({'access': accessToken}));
    debugPrint(response.statusCode.toString());
    Get.to(MyApp());
  }
}
