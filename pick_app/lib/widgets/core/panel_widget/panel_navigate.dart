import 'package:flutter/material.dart';

import '../../../pages/book_page/book_page.dart';
import '../../../pages/navigate_page/navigate_page.dart';

class PanelNavigate extends StatefulWidget {
  final String destination;
  
  final String source;

  const PanelNavigate({Key? key, required this.destination, required this.source}) : super(key: key);

  @override
  State<PanelNavigate> createState() => _PanelNavigateState();
}

class _PanelNavigateState extends State<PanelNavigate> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child:      
        ListView(
            children:  [
              ListTile(
                title: widget.source == '' ? const Text('Source location') : Text(widget.source),
                leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01)),
                onTap: (){},
              ),
              ListTile(
                title: widget.destination == '' ? const Text('Destination') : Text(widget.destination),
                leading: const Icon(Icons.flag, color: Colors.redAccent,),
                onTap: (){},
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add_location_rounded, color:Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const NavigatePage()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
                        label: const Text(
                          'Select Location',
                          style: TextStyle(color: Colors.white),
                        ),
            )),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const BookPage()));
                  // Respond to button press
              },
              icon: const Icon(Icons.book_rounded, size: 18),
              label: const Text("Want to escape hassle? Book your rider here"),
            )
            ],
          ),
      );
  }
}