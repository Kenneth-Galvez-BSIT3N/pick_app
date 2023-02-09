
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pick_app/pages/book_page/book_page.dart';
import 'package:pick_app/pages/homepage/homepage.dart';
import 'package:pick_app/pages/navigate_page/navigate_page.dart';
import 'package:pick_app/pages/view_book_page/view_book_page.dart';
import 'package:pick_app/widgets/core/panel_widget/panel_booked_rider.dart';
import 'package:pick_app/widgets/core/panel_widget/panel_booked_user.dart';
import 'package:pick_app/widgets/core/panel_widget/panel_navigate.dart';
import 'package:pick_app/widgets/core/panel_widget/panel_navigate_rider.dart';

class PanelWidget extends StatefulWidget {
  final ScrollController controller;
  final String source;
  final String destination;
  final Map userDetails;
  const PanelWidget({Key? key, required this.controller, this.source = '', this.destination = '', required this.userDetails}) : super(key: key);

  @override
  State<PanelWidget> createState() => _PanelWidgetState();
}

class _PanelWidgetState extends State<PanelWidget> {
  List userBooking = [];
  String bookingId = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('users').snapshots(includeMetadataChanges: true);
  
//   Future<void> updateUser() {
//   return users
//     .doc(userBooking[0]['uid'])
//     .update({'on_book': false})
//     .then((value) => print("User Updated"))
//     .catchError((error) => print("Failed to update user: $userBooking[0]['uid']"));
// }

// Future<void> updateRider() {
//   return users
//     .doc(userBooking[0]['rider_id'])
//     .update({'on_book': false})
//     .then((value) => print("User Updated"))
//     .catchError((error) => print("Failed to update user: $userBooking[0]['rider_id']"));
// }

// Future<void> updateBookings() {
//   return bookings
//     .doc(widget.id)
//     .update({
//       'status': "ongoing",
//       'rider_id':auth.currentUser?.uid.toString(),
//       })
//     .then((value) => print("User Updated"))
//     .catchError((error) => print("Failed to update user: $error"));
// }


  void getOnBooking(){
    final User? user = auth.currentUser;
    final uid = user?.uid;
    FirebaseFirestore.instance
    .collection('bookings')
    .where('status', isEqualTo: 'ongoing')
    .get()
    .then((value) => {
        for (var element in value.docs) { 
          if(element['rider_id'] == uid || element['uid'] == uid){
            setState(() {
            userBooking.add(element);
            bookingId = element.id;
          })
          }
          
        }
      
    });
  }

  // void dropOffBooking(){
  //   updateRider();
  //   updateUser();
  //   setState(() {
  //     widget.userDetails['on_book'] = false;
  //   });
  // }
  @override
  void initState() {
    getOnBooking();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return 
    widget.userDetails['on_book'] == false ?
    Container(
      margin: const EdgeInsets.only(top:10,left: 20, right: 20),
      child:
      widget.userDetails['user_type'] == 'user' ?
      PanelNavigate(source: widget.source, destination: widget.destination,)
      :
      const PanelNavigateRider()
    )
    :
    Container(
      child: 
      widget.userDetails['user_type'] == 'user' ?
      PanelBookedUser(uid: widget.userDetails['uid'],)
      :
      PanelBookedRider(uid: widget.userDetails['uid'], bookId: bookingId, userBooking: userBooking)

      
    );
  }
}
// class PanelWidget extends StatelessWidget {
//   final ScrollController controller;
//   final String source;
//   final String destination;
//   final Map userDetails;
//   const PanelWidget({Key? key, required this.controller, this.source = '', this.destination = '', required this.userDetails}) : super(key: key);
  
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(top:10,left: 20, right: 20),
//       child:
//       userDetails['user_type'] == 'user' ?
//       Container(
//         child: userDetails['on_book'] == false ?       
//         ListView(
//             children:  [
//               ListTile(
//                 title: source == '' ? const Text('Source location') : Text(source),
//                 leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01)),
//                 onTap: (){},
//               ),
//               ListTile(
//                 title: destination == '' ? const Text('Destination') : Text(destination),
//                 leading: const Icon(Icons.flag, color: Colors.redAccent,),
//                 onTap: (){},
//               ),
//               const SizedBox(height: 8.0),
//               SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: 50,
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.add_location_rounded, color:Colors.white),
//                         onPressed: () {
//                           Navigator.push(
//                             context, 
//                           MaterialPageRoute(builder: (context)=> const NavigatePage()));
//                         },
//                         style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
//                         label: const Text(
//                           'Select Location',
//                           style: TextStyle(color: Colors.white),
//                         ),
//             )),
//             const SizedBox(height: 20),
//             TextButton.icon(
//               onPressed: () {
//                 Navigator.push(
//                             context, 
//                           MaterialPageRoute(builder: (context)=> const BookPage()));
//                   // Respond to button press
//               },
//               icon: const Icon(Icons.book_rounded, size: 18),
//               label: const Text("Want to escape hassle? Book your rider here"),
//             )
//             ],
//           )
//           :
//           Column(
//             children: const [],
//           ),
//       )
      
//           : 
//           Container(
//             child: userDetails['on_book'] == false ?
//             Expanded(child: 
//             ListView(
//                 children: [
//                   ListTile(
//                     title: const Text('User Full Name'),
//                     leading: const Icon(Icons.location_pin, color: Colors.yellow),
//                     onTap: (){
//                       Navigator.push(
//                             context, 
//                           MaterialPageRoute(builder: (context)=> const ViewBookPage()));
//                     },  
//                   ),
//                 ],
//               )
//             )
//             :
//           ListView(
//             children:[
//               ListTile(
//                 title: source == '' ? const Text('Source location') : Text(source),
//                 leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01)),
//                 onTap: (){},
//               ),
//               ListTile(
//                 title: destination == '' ? const Text('Destination') : Text(destination),
//                 leading: const Icon(Icons.flag, color: Colors.redAccent,),
//                 onTap: (){},
//               ),
//               const SizedBox(height: 8.0),
//               SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: 50,
//                       child: ElevatedButton.icon(
//                         icon: const Icon(Icons.add_location_rounded, color:Colors.white),
//                         onPressed: () {
//                           Navigator.push(
//                             context, 
//                           MaterialPageRoute(builder: (context)=> const NavigatePage()));
//                         },
//                         style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
//                         label: const Text(
//                           'Select Location',
//                           style: TextStyle(color: Colors.white),
//                         ),
//             )),
//             ],
//           ),
//           )
//     );
//   }
// }