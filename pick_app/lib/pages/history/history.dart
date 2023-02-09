import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pick_app/pages/history/history_details.dart';
import 'package:pick_app/pages/login/login.dart';

import '../../widgets/core/drawer/drawer.dart';

class HistoryPage extends StatefulWidget {
  final displayName;
  final email;
  const HistoryPage({Key? key, this.displayName, this.email}) : super(key: key);
  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  List userHistory = [];

  void getHistory(){
    final User? user = auth.currentUser;
    final uid = user?.uid;
    FirebaseFirestore.instance
    .collection('bookings')
    .where('status', isEqualTo: 'done')
    .get()
    .then((value) => {
        for (var element in value.docs) { 
          if(element['rider_id'] == uid || element['uid'] == uid){
            setState(() {
              userHistory.add(element);
          })
          }
          
        }
      
    });
  }
  @override
  void initState() {
    
    super.initState();
  }
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
        drawer: DrawerWidget(displayName: widget.displayName,email: widget.email,),
        body: Container(
          margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child:  ListView(
              children: [
                for(var element in userHistory)
                Row(
                  children: [
                    ListTile(
                  title: const Text('Address 1'),
                  subtitle: const Text('Date and Time of booking'),
                  onTap: (){
                    Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const HistoryDetails()));
                  },
                  ),
                const  Divider(color: Colors.grey,),
                  ],
                )
                
              //  ListTile(
              //     title: const Text('Address 1'),
              //     subtitle: const Text('Date and Time of booking'),
              //     onTap: (){},
              //   ),
              //  const  Divider(color: Colors.grey,),
              //  ListTile(
              //     title: const Text('Address 1'),
              //     subtitle: const Text('Date and Time of booking'),
              //     onTap: (){},
              //   ),
              //  const  Divider(color: Colors.grey,)
              ],
            ),
        
         )
      );
  }
}