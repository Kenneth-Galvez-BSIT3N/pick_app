import 'package:flutter/material.dart';
import 'package:pick_app/pages/book_page/book_page.dart';

class PanelWidget extends StatelessWidget {
  final ScrollController controller;
  const PanelWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top:10,left: 20, right: 20),
      child:ListView(

            children:  [
              ListTile(
                title: const Text('0951 Unit 1 Hilario Compound Santa Rita Guiguinto, Bulacan'),
                leading: const Icon(Icons.location_pin, color: Colors.yellow),
                onTap: (){},
              ),
              ListTile(
                title: const Text('478 Tabang, HGuiguinto, Bulacan'),
                leading: const Icon(Icons.flag, color: Colors.redAccent,),
                onTap: (){},
              ),
              const SizedBox(height: 8.0),
              SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.directions, color:Colors.black),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                        label: const Text(
                          'Navigate this Location',
                          style: TextStyle(color: Colors.black),
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
          ));
  }
}