import 'package:flutter/material.dart';

class RegisterRider extends StatefulWidget {
  const RegisterRider({Key? key}) : super(key: key);

  @override
  State<RegisterRider> createState() => _RegisterRiderState();
}

class _RegisterRiderState extends State<RegisterRider> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE1AD01),
      ),
      body: Container(), //Dito ka magstart ng code mo
    );
  }
}