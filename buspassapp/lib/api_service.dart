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
    final response = await http.get(
        Uri.parse("$baseUrl/get-pass-details/$bioId/"),
        headers: <String, String>{
          'Content-Type': "application/json",
          'Authorization': ctrl.authToken
        });
    // debugPrint(response.body.runtimeType.toString());
    if (response.statusCode == 200) {
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
    final responseJson = jsonDecode(response.body);
    final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    if (response.statusCode == 200) {
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

class LogOutService {
  String authToken;
  LogOutService({required this.authToken});
  void logOut() async {
    final response = await http.post(Uri.parse('$baseUrl/log'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{'access': ctrl.authToken}));
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
      headers: headers, body: {'access': accessToken});
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

    if (pref.containsKey("access")) {
      accessToken = pref.getString("access");
      if (accessToken == null) {
        accessToken = "";
      } else {
        accessToken = accessToken!.substring(7, accessToken!.length);
      }
      debugPrint(accessToken);
      return true;
    } else {
      debugPrint("asdfasdsssssssssssssssssss");
      debugPrint(accessToken);
      return false;
    }

    // if (pref.containsKey("access")) {
    //   accessToken = pref.getString("access");
    //   accessToken = accessToken!.substring(7, accessToken!.length);
    //   if (accessToken != null && await checkTokenValidity(accessToken)) {
    //     return true;
    //   } else {
    //     return true;
    //   }
    //   //INCOMPLETE DIDNT USE API TO CHECK FOR VALIDITY
    // } else {
    //   return true;
    // }
  }
}
