import 'dart:async';

import 'package:buspassapp/api_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:buspassapp/main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  void isLogin() async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    // String? access_token = sp.getString("access");

    // if (isLogin) {
    //   Timer(const Duration(seconds: 5), () {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const HomeScreen()));
    //   });
    // } else {
    //   Timer(const Duration(seconds: 5), () {
    //     Navigator.push(context,
    //         MaterialPageRoute(builder: (context) => const LoginScreen()));
    //   });
    // }
  }

  Future<bool> checkTokenService() async {
    return await CheckAccessTokenService().checkAccessToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: FutureBuilder(
              future: checkTokenService(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  // print(snapshot.data);
                  if (snapshot.data == true) {
                    return const Home();
                  } else {
                    return MyApp();
                  }
                } else {
                  return const CircularProgressIndicator(
                    backgroundColor: Color.fromARGB(255, 0, 11, 135),
                    color: Color.fromARGB(255, 242, 226, 0),
                  );
                }
              })),
    );
  }
}
