import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pick_app/pages/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

startTime() async {
    var duration = const Duration(seconds: 6);
    return Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context) => const Login()
      )
    ); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.asset('assets/logo.jpg'),
    );
  }
}