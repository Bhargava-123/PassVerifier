import 'dart:convert';
import 'package:buspassapp/Controller.dart';
import 'package:buspassapp/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

String baseUrl = "http://127.0.0.1:8000/api";
final controller = Get.put(ControllerPage());
final ControllerPage ctrl = Get.find();

class PassService {
  String bioId;
  PassService({required this.bioId});
  Future<List<dynamic>> getDetails() async {
    final response =
        await http.get(Uri.parse("$baseUrl/get-pass-details/$bioId/"),
        headers: <String,String>{
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
      Uri.parse('$baseUrl/token/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    //after submitting response
    final responseJson = jsonDecode(response.body);
    if (response.statusCode == 200) {
      // successSnack("Successful Login","");
      // debugPrint(responseJson['access']);
      controller.setToken(responseJson['access']);

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
