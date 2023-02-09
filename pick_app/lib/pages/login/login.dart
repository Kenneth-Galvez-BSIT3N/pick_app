import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pick_app/main.dart';
import 'package:pick_app/pages/homepage/homepage.dart';
import 'package:pick_app/pages/register/register_rider.dart';
import 'package:pick_app/pages/register/register_user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with TickerProviderStateMixin {
  late AnimationController controller;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool buttonFlag = false;
  String errorText = '';
  Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
    // Ideal time to initialize
    // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
    //...
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..addListener(() {
        setState(() {});
      });
    controller.repeat(reverse: true);
    super.initState();
    main();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
      } else {
        // print(user);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: ((context) => Homepage(
                      navigateBool: false,
                      displayName: user.displayName,
                      email: user.email,
                      photoUrl: user.photoURL,
                    ))));
      }
    }).onError((error) => {});
  }

  void LoginUser() async {
    if (_username.text == '' || _password.text == '') {
      setState(() {
        errorText = 'Please input all fields.';
        buttonFlag = false;
      });
    } else {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _username.text, password: _password.text)
            .then((value) => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => Homepage(
                                navigateBool: false,
                                displayName: value.user?.displayName,
                                email: value.user?.email,
                                photoUrl: value.user?.photoURL,
                                uid: value.user?.uid,
                              ))))
                })
            .catchError((error) => {print(error)});
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            buttonFlag = false;
            errorText = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            buttonFlag = false;
            errorText = 'Wrong password provided for that user.';
          });
        }
      }
    }

// await FirebaseAuth.instance.signOut();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
              // margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
              child: ListView(
            padding: const EdgeInsets.all(8),
            children: <Widget>[
              Image.asset('assets/logo.jpg'),
              const SizedBox(
                height: 30,
              ),
              Text(
                errorText,
                style: TextStyle(color: Colors.red),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _username,
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
                height: 20,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => buttonFlag
                        ? null
                        : {
                            LoginUser(),
                            // setState(() {
                            //   buttonFlag = true;
                            // }),
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow,
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.black),
                    ),
                  )),
              const SizedBox(height: 10),
              Visibility(
                visible: buttonFlag,
                child: CircularProgressIndicator(
                  value: controller.value,
                  semanticsLabel: 'Circular progress indicator',
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterUser()));
                  },
                  child: const Text('Dont have account? Sign up here.')),
              TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterRider()));
                  },
                  child: const Text(
                      'Need a rider account?. Register as driver here.'))
            ],
          ))),
    );
  }
}

class MaterialStatePropertyAll {}
