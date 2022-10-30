import 'package:flutter/material.dart';
import 'package:google_place/google_place.dart';
import 'package:pick_app/pages/homepage/homepage.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {

  late GooglePlace googlePlace; 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String apiKey = 'AIzaSyBFXJES_kQ6-_s7ZbH2sx0-FanKWLqyux0';
    googlePlace = GooglePlace(apiKey);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: 
      Column(
        children: [
        TextFormField(
          initialValue: '',
          decoration: const InputDecoration(
            hintText: "Current Location",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_pin, color: Colors.yellow,)
          ),
        ),

        const SizedBox(height: 50,
        child: Icon(Icons.arrow_downward),),
        TextFormField(
            initialValue: '',
            decoration: const InputDecoration(
              hintText: "Destination",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.flag, color: Colors.yellow,),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
         Expanded(
            child: SizedBox(
              height: 42.0,
              child: ListView(
            children: const [
              ListTile(
                title: Text('Location 1'),
                leading: Icon(Icons.location_pin),
              ),
              ListTile(
                title: Text('Location 2'),
                leading: Icon(Icons.location_pin),
              ),
            ],
          )),
  ),
  const SizedBox(
          height: 10,
        ),
        Row(
          children:const  [
            Text('Total Price: '),
            Text('₱00.00', style: TextStyle(fontSize: 24,),),
        ]),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.book),
            onPressed: () {
              Navigator.push(
                context, 
              MaterialPageRoute(builder: (context)=> const Homepage()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
            label: const Text(
              'Book a Rider',
              style: TextStyle(color: Colors.black),
            ),
          )),
          
      ]),
    ));
  }
}