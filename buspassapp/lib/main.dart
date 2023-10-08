import 'package:buspassapp/pass_details_screen.dart';
import 'package:buspassapp/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:buspassapp/scan_logs.dart';
import 'package:buspassapp/scanner.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:buspassapp/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamily: 'Montserrat'),
    title: "Named Routes Demo",
    initialRoute: Routes.SplashScreen,
    getPages: getPages,
  ));
}

final getPages = [
  GetPage(
    name: Routes.MyAppScreen,
    page: () => MyApp(),
  ),
  GetPage(name: Routes.SplashScreen, page: () => const SplashScreen()),
  GetPage(name: Routes.HomeScreen, page: () => const Home()),
  GetPage(name: Routes.ScanLogsScreen, page: () => const ScanLogs()),
  GetPage(name: Routes.ScannerScreen, page: () => Scanner()),
  GetPage(
    name: Routes.PassDetailsScreen,
    page: () => const PassDetailsScreen(),
  )
];

class Routes {
  static String MyAppScreen = '/';
  static String HomeScreen = '/home';
  static String ScanLogsScreen = '/scanLogs';
  static String ScannerScreen = '/scanner';
  static String PassDetailsScreen = '/passDetails';
  static String SplashScreen = '/splashScreen';
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 10.0),
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Pass Verifier",
                style: TextStyle(fontSize: 35),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 23.0,
              )
            ],
          )),
        ),
        backgroundColor: const Color(0xFF01267C),
        shadowColor: const Color.fromARGB(0, 255, 255, 255),
      ),
      backgroundColor: const Color(0xFF01267C),
      //body of the Login page
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 10.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //SEC LOGO
              Padding(
                padding: const EdgeInsets.only(top: 80.0, bottom: 100.0),
                child: Image.asset(
                  'assets/images/seclogo.png',
                  height: 170,
                  width: 170,
                ),
              ),
              const FormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  const FormWidget({super.key});

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //username TextField
        CustomTextField(
          hintTextValue: "Username",
          textEditingController: usernameController,
        ),
        const SizedBox(
          height: 40,
          width: 100,
        ),
        //password TextField
        PasswordTextField(
          textEditingController: passwordController,
        ),
        const SizedBox(
          height: 40,
          width: 100,
        ),
        SizedBox(
          child: Container(
            width: 120,
            height: 50,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: ElevatedButton(
              onPressed: () async {
                AuthenticateService(
                        username: usernameController.text,
                        password: passwordController.text)
                    .getDetails();
                // pref.setString('access', ctrl.authToken);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 248, 166, 3),
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                'LOG IN',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        )
      ],
    );
  }
}

class PasswordTextField extends StatefulWidget {
  final TextEditingController textEditingController;
  const PasswordTextField({super.key, required this.textEditingController});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextField(
          controller: widget.textEditingController,
          obscureText: passwordVisible,
          decoration: InputDecoration(
              filled: true,
              border: const OutlineInputBorder(),
              fillColor: const Color.fromARGB(255, 211, 211, 211),
              hintText: "Password",
              suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                      () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  }))),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String hintTextValue;
  final TextEditingController textEditingController;
  const CustomTextField(
      {super.key,
      required this.hintTextValue,
      required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
            filled: true,
            border: const OutlineInputBorder(),
            hintText: hintTextValue,
            fillColor: const Color.fromARGB(255, 211, 211, 211)),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Pass Verifier",
                    style: TextStyle(fontSize: 35),
                  ),
                  PopupMenuButton(
                      itemBuilder: (context) => [
                            PopupMenuItem(
                              child: const Text("Log Out"),
                              onTap: () async {
                                Get.to(MyApp());
                              },
                            ),
                          ])
                ],
              ),
            )),
          ),
          backgroundColor: const Color(0xFF01267C),
          shadowColor: const Color.fromARGB(0, 255, 255, 255),
        ),
        backgroundColor: const Color(0xFF01267C),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(80.0),
              child: Image.asset(
                'assets/images/seclogo.png',
                height: 170,
                width: 170,
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Button('Scan Logs', '/scanLogs'),
                SizedBox(
                  height: 50,
                  width: 100,
                ),
                Button('Scanner', '/scanner')
              ],
            ),
          ],
        ));
  }
}

class Button extends StatelessWidget {
  final String buttonName;
  final String routeName;
  const Button(this.buttonName, this.routeName, {super.key});
  @override
  Widget build(context) {
    return Center(
        child: ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(320, 180),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color.fromARGB(255, 248, 166, 3)),
      child: Text(
        buttonName,
        style: const TextStyle(
            color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold),
      ),
    ));
  }
}

successSnack(title, subtitle) {
  Get.snackbar(
    title,
    subtitle,
    colorText: Colors.white,
    backgroundColor: Colors.black,
    snackPosition: SnackPosition.BOTTOM,
    borderRadius: 5.0,
    margin: const EdgeInsets.all(10),
    duration: const Duration(milliseconds: 2000),
  );
}

failedSnack(title, subtitle) {
  Get.snackbar(
    title,
    subtitle,
    colorText: Colors.white,
    backgroundColor: Colors.red,
    snackPosition: SnackPosition.BOTTOM,
    borderRadius: 5.0,
    margin: const EdgeInsets.all(10),
    duration: const Duration(milliseconds: 2000),
  );
}
