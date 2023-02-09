import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../homepage/homepage.dart';

class ViewBookPage extends StatefulWidget {
  final Map details;
  final String id;
  const ViewBookPage({Key? key, required this.details, required this.id}) : super(key: key);

  @override
  State<ViewBookPage> createState() => _ViewBookPageState();
}

class _ViewBookPageState extends State<ViewBookPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');
  final FirebaseAuth auth = FirebaseAuth.instance; 

  Future<void> updateUser() {
  return users
    .doc(widget.details['uid'])
    .update({'on_book': true})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}

Future<void> updateRider() {
  return users
    .doc(auth.currentUser?.uid.toString())
    .update({'on_book': true})
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}

Future<void> updateBookings() {
  return bookings
    .doc(widget.id)
    .update({
      'status': "ongoing",
      'rider_id':auth.currentUser?.uid.toString(),
      })
    .then((value) => print("User Updated"))
    .catchError((error) => print("Failed to update user: $error"));
}

  void acceptBooking(){
    updateUser();
    updateRider();
    updateBookings();
    Navigator.push(
        context, 
      MaterialPageRoute(builder: (context)=> const Homepage(
        navigateBool: true,
        )));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE1AD01),
      ),
      body: ListView(
          children: <Widget>[
            SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                child: Flexible(child: Text(widget.details['fullname'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                ),
            const SizedBox(height: 20,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                child: Flexible(child:  Text(widget.details['pickup_location'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                ),
            const SizedBox(height: 20,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                child: Flexible(child:  Text(widget.details['destination'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                ),
            const SizedBox(height: 20,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                child: Flexible(child: Text(widget.details['description'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                ),
            const SizedBox(height: 20,),
            SizedBox(width: MediaQuery.of(context).size.width * 0.5,
                child: Flexible(child:  Text(widget.details['price'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                ),
            const SizedBox(height: 20,),
            SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.book),
            onPressed: (){
              acceptBooking();
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
            label: const Text(
              'Accept Booking',
              style: TextStyle(color: Colors.white),
            ),
          )),
          ],
      ),
    );
  }
}


// ListView(
//           children: <Widget>[
//             Expanded(child: 
//               Row(
//               children: [
                
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.4,
//                 child: const Text('Full Name:', style: TextStyle(fontSize: 20),),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.5,
//                 child: Flexible(child: Text(widget.details['fullname'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
//                 ),
                
//               ],
//             ),
//             ),
//             const SizedBox(height: 20,),
//             Expanded(child: Row(
//               children: [
                
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.4,
//                 child: const Text('Pick Up Location:', style: TextStyle(fontSize: 20),),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.5,
//                 child: Flexible(child:  Text(widget.details['pickup_location'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
//                 ),
                
//               ],
//             ),),
//             const SizedBox(height: 20,),
//             Expanded(child: Row(
//               children: [
                
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.4,
//                 child: const Text('Destination Location:', style: TextStyle(fontSize: 20),),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.5,
//                 child: Flexible(child:  Text(widget.details['destination'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
//                 ),
                
//               ],
//             ),),
//             const SizedBox(height: 20,),
//             Expanded(child: Row(
//               children: [
                
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.4,
//                 child: const Text('Description:', style: TextStyle(fontSize: 20),),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.5,
//                 child: Flexible(child: Text(widget.details['description'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
//                 ),
                
//               ],
//             ),),
//             const SizedBox(height: 20,),
//             Expanded(child: Row(
//               children: [
                
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.4,
//                 child: const Text('Price:', style: TextStyle(fontSize: 20),),
//                 ),
//                 SizedBox(width: MediaQuery.of(context).size.width * 0.5,
//                 child: Flexible(child:  Text(widget.details['price'], style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
//                 ),
                
//               ],
//             ),),
//             const SizedBox(height: 20,),
//             SizedBox(
//           width: MediaQuery.of(context).size.width,
//           height: 50,
//           child: ElevatedButton.icon(
//             icon: const Icon(Icons.book),
//             onPressed: (){
//               acceptBooking();
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
//             label: const Text(
//               'Accept Booking',
//               style: TextStyle(color: Colors.white),
//             ),
//           )),
//           ],
//       ),