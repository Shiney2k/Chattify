import 'dart:async';

import 'package:flutter/material.dart';

import 'package:chattify/Screens/login_screen.dart';

void main() {
  runApp(const SplashScreen());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return initWidget(context);
  }

  Widget initWidget(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 2, 108, 179),
                gradient: LinearGradient(colors: [
                  (Color.fromARGB(255, 1, 8, 71)),
                  Color.fromARGB(255, 30, 182, 242)
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          ),
          Center(
            child: Image.asset(
              "images/app_icon.png",
              height: 90,
              width: 90,
            ),
          )
        ],
      ),
    );
  }
}
