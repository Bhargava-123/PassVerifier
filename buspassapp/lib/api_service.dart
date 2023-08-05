import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PassService {
  String bioId;
  PassService({required this.bioId});
  Future<List<dynamic>> getDetails() async {
    final response = await http
        .get(Uri.parse("http://127.0.0.1:8000/api/get-pass-details/$bioId/"));
    debugPrint(response.body);
    return Future.value(jsonDecode(response.body));
  }
}

class ScanService{
  String date;
  ScanService({required this.date});
  Future<List<dynamic>> getDetails() async {
    final response = await http
        .get(Uri.parse("http://127.0.0.1:8000/api/get-scan-log/$date/"));
        try{
        debugPrint(jsonDecode(response.body)[0]['student_list'].toString());
        }
        catch(err){
          debugPrint("No data found");
        }
    return Future.value(jsonDecode(response.body));
  }

}
