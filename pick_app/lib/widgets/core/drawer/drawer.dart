import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pick_app/pages/about/about.dart';
import 'package:pick_app/pages/history/history.dart';
import 'package:pick_app/pages/homepage/homepage.dart';

class DrawerWidget extends StatefulWidget {
  final String? title;
  final String? displayName;
  final String? email;
  const DrawerWidget({Key? key, this.title, this.displayName = "", this.email = ""}) : super(key: key);

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  int _selectedDestination = 0;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Row(
      children: [
        Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.35,
                color: const Color(0xffE1AD01),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top:20),
                      height: 115,
                      width: 115,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage('https://ui-avatars.com/api/?name=${widget.displayName.toString()}'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.displayName.toString() == '' || widget.displayName.toString() == 'null' ? 'No Name' : widget.displayName.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(widget.email.toString() == '' || widget.email.toString() == 'null' ? 'No Email' : widget.email.toString(), style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),),
                  ],                ),              
                ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Map'),
                onTap: (){
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Homepage(navigateBool: false,),
                  ),
                );
        },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('History'),
                onTap: (){
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HistoryPage(),
                  ),
                );
        },
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              // const Padding(
              //   padding:  EdgeInsets.all(16.0),
              //   child: Text(
              //     'Label',
              //   ),
              // ),
              ListTile(
                leading: const Icon(Icons.question_mark),
                title: const Text('About'),
                onTap: (){
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutPage(),
                  ),
                );
        },
              ),
            ],
          ),
        ),
        const VerticalDivider(
          width: 1,
          thickness: 1,
        ),
      ],
    );
  }

  void selectDestination(int index) {
    setState(() {
      _selectedDestination = index;
    });
  }
  
}