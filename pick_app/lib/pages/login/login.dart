import 'package:flutter/material.dart';
import 'package:pick_app/pages/homepage/homepage.dart';
import 'package:pick_app/pages/register/register_rider.dart';
import 'package:pick_app/pages/register/register_user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
              margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: Column(
                children: [
                  Image.asset('assets/logo.jpg'),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your username'
                        // suffixIcon: Icon(
                        //   Icons.error,
                        // ),
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: '',
                    decoration: const InputDecoration(
                      fillColor: Colors.yellow,
                      labelText: 'Password',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2)),
                      hintText: 'Enter your password',
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const Homepage()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                        child: const Text(
                          'LOGIN',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                  const SizedBox(height: 10),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const RegisterUser()));
                      },
                      child: const Text('Dont have account? Sign up here.')),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const RegisterRider()));
                      },
                      child: const Text(
                          'Need a rider account?. Register as driver here.'))
                ],
              ))),
    );
  }
}

class MaterialStatePropertyAll {}
