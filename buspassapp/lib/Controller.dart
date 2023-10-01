import 'package:get/get.dart';

var baseURl = "http://127.0.0.1:8000/";

class ControllerPage extends GetxController {
  late String authToken;
  void setToken(token) {
    // print('*' * 20);
    // print(token);
    authToken = 'Bearer $token';
    update();
  }
}
