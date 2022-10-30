import 'package:flutter/material.dart';
import 'package:pick_app/pages/about/about.dart';
import 'package:pick_app/pages/history/history.dart';
import 'package:pick_app/pages/homepage/homepage.dart';

class DrawerWidget extends StatefulWidget {
  final String? title;
  const DrawerWidget({Key? key, this.title}) : super(key: key);

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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column( //You will start program here Mike
                  children: const [
                    Text('Bogart Bardagul')
                  ],
                )
              ),
              const Divider(
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: const Icon(Icons.map),
                title: const Text('Map'),
                selected: _selectedDestination == 0,
                onTap: (){
                Navigator.pop(context);
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Homepage(),
                  ),
                );
        },
              ),
              ListTile(
                leading: const Icon(Icons.list),
                title: const Text('History'),
                selected: _selectedDestination == 1,
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
              const Padding(
                padding:  EdgeInsets.all(16.0),
                child: Text(
                  'Label',
                ),
              ),
              ListTile(
                leading: const Icon(Icons.question_mark),
                title: const Text('About'),
                selected: _selectedDestination == 3,
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