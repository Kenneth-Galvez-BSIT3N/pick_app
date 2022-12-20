// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_app/pages/login/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../main.dart';

class RegisterRider extends StatefulWidget {
  const RegisterRider({Key? key}) : super(key: key);

  @override
  State<RegisterRider> createState() => _RegisterRiderState();
}

class _RegisterRiderState extends State<RegisterRider> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _fullname = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _confirmPassword = TextEditingController();
  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
  // Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  }

  void registerRider(fullname,phone_number)async{
    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _password.text,
      ).then(((value) => {
        value.user?.updateDisplayName(fullname),
        firestoreInstance.collection("users").doc(auth.currentUser?.uid.toString()).set({
          "full_name":_fullname.text,
          "email":_email.text,
          "uid":value.user?.uid,
          "on_book":false,
          "phone_number":phone_number,
          "user_type": "rider"
        }).then((value)=> {}),
        Navigator.push(context, MaterialPageRoute(builder:((context) => const Login())))
      }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE1AD01),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          children: [
            const Text('Register here as a Rider', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
                    controller: _fullname,
                    decoration: const InputDecoration(
                        labelText: 'Full name',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your Full Name'
                        // suffixIcon: Icon(
                        //   Icons.error,
                        // ),
                        ),
                  ),
            const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your Email'
                        // suffixIcon: Icon(
                        //   Icons.error,
                        // ),
                        ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _phoneNumber,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                        hintText: 'Enter your Phone Number'
                        // suffixIcon: Icon(
                        //   Icons.error,
                        // ),
                        ),
                  ),
            const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
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
                    height: 10,
                  ),
                  TextFormField(
                    controller: _confirmPassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                      fillColor: Colors.yellow,
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.yellow, width: 2)),
                      hintText: 'Confirm your password',
                      // suffixIcon: Icon(
                      //   Icons.error,
                      // ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigator.push(
                          //   context, 
                          // MaterialPageRoute(builder: (context)=> const Homepage()));
                          registerRider(_fullname.text,_phoneNumber.text);
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                        child: const Text(
                          'REGISTER',
                          style: TextStyle(color: Colors.black),
                        ),
                      )),
                const SizedBox(height: 10,),
                TextButton(
                      onPressed: () {
                        Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const  Login()));
                      },
                      child: const Text('Already have an account? Sign in instead')),
          ],
        ),
      ), //Dito ka magstart ng code mo
    );
  }
}