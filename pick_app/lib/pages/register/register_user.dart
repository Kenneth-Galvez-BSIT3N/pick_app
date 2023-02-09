// ignore_for_file: non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pick_app/pages/login/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _phoneNumber = TextEditingController();
  TextEditingController _fullname = TextEditingController();
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
  // Ideal time to initialize
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //...

  void registeruser(fullname, phone_number) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: _email.text,
            password: _password.text,
          )
          .then(((value) => {
                value.user?.updateDisplayName(fullname),
                firestoreInstance
                    .collection("users")
                    .doc(auth.currentUser?.uid.toString())
                    .set({
                  "full_name": _fullname.text,
                  "email": _email.text,
                  "uid": value.user?.uid,
                  "on_book": false,
                  "phone_number": phone_number,
                  "user_type": "user"
                }).then((value) => {}),
                Navigator.push(context,
                    MaterialPageRoute(builder: ((context) => const Login())))
              }));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
      } else if (e.code == 'email-already-in-use') {
        ;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xffE1AD01),
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            const Text(
              'Register here as User',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
              keyboardType: TextInputType.emailAddress,
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
                    borderSide: BorderSide(color: Colors.yellow, width: 2)),
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
                    borderSide: BorderSide(color: Colors.yellow, width: 2)),
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
                    registeruser(_fullname.text, _phoneNumber.text);
                  },
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: const Text(
                    'REGISTER',
                    style: TextStyle(color: Colors.black),
                  ),
                )),
            const SizedBox(
              height: 10,
            ),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text('Already have an account? Sign in instead')),
          ],
        ),
      ),
    );
  }
}
