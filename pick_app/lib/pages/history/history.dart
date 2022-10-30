import 'package:flutter/material.dart';
import 'package:pick_app/pages/login/login.dart';

import '../../widgets/core/drawer/drawer.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        
        appBar: AppBar(
          title: const Text('History'),
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
      );
  }
}