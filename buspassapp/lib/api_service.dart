import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseUrl = "http://127.0.0.1:8000/api";

class PassService {
  String bioId;
  PassService({required this.bioId});
  Future<List<dynamic>> getDetails() async {
    final response =
        await http.get(Uri.parse("$baseUrl/get-pass-details/$bioId/"));
    // debugPrint(response.body.runtimeType.toString());
    if (response.body == '[]') {
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
    final response = await http.get(Uri.parse("$baseUrl/get-scan-log/$date/"));
    try {
      // debugPrint(jsonDecode(response.body).toString());
    } catch (err) {
      return Future.value([]);
    }
    return Future.value(jsonDecode(response.body));
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
      Uri.parse('$baseUrl/authenticate/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    // debugPrint(response.body.runtimeType.toString());
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
    var response = await http.post(
      Uri.parse('$baseUrl/post-scan-log/$date/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
