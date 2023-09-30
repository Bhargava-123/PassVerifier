import 'package:get/get.dart';

var baseURl = "http://127.0.0.1:8000/";

class ControllerPage extends GetxController {
  late String authToken;
  void setToken(token) {
    authToken = 'Bearer $token';
    update();
  }
}
