import 'package:flutter/material.dart';
import 'package:pick_app/pages/login/login.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../widgets/core/drawer/drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home Page",
      home: Scaffold(
        
        appBar: AppBar(
          title: const Text('About us'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    leading: TextButton.icon(
                    onPressed: () {
                       Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const Login()));
                    },
                    icon: const Icon(Icons.logout, color: Colors.black),
                    label: const Text(""),
                  ),
                    title: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: const Color(0xffE1AD01),
        ),
        drawer: const DrawerWidget(),
        body: Container() //Start your code here
      ),
    );
  }
}