import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_app/pages/homepage/homepage.dart';

class PanelBookedRider extends StatefulWidget {
  final String uid;
  final String bookId;
  final List userBooking;
  const PanelBookedRider({Key? key, required this.uid, required this.bookId, required this.userBooking}) : super(key: key);

  @override
  State<PanelBookedRider> createState() => _PanelBookedRiderState();
}

class _PanelBookedRiderState extends State<PanelBookedRider> {
  Map bookingInformation = {};

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference bookings = FirebaseFirestore.instance.collection('bookings');

  Future<void> updateUser() {
  return users
    .doc(widget.userBooking[0]['uid'])
    .update({'on_book': false})
    .then((value) => print("User Updated"));
}

Future<void> updateRider() {
  return users
    .doc(widget.userBooking[0]['rider_id'])
    .update({'on_book': false})
    .then((value) => print("Rider Updated"));
}


Future<void> updateBooking() {
  return bookings
    .doc(widget.bookId)
    .update({'status': 'done'})
    .then((value) => print("Booking Updated"));
}


  void getUserBooking(uid){
    FirebaseFirestore.instance
    .collection('bookings')
    .where('rider_id', isEqualTo: uid)
    .get()
    .then((value) => {
      setState((){
        bookingInformation = {
          'pickup_location': value.docs[0].data()['pickup_location'],
          'destination': value.docs[0].data()['destination']
        };
      })
    });
  }

  
  void dropOffBooking(){
    updateRider();
    updateUser();
    updateBooking();
    print(widget.bookId);
    setState(() {
      
    });
  }

  @override
  void initState() {
    getUserBooking(widget.uid);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ListView(
            children:[
              ListTile(
                title: bookingInformation.isEmpty ?    const Text('pick-up location'): Text(bookingInformation['pickup_location']),
                leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01)),
                onTap: (){},
              ),
              ListTile(
                title: bookingInformation.isEmpty ?   const Text('destination'): Text(bookingInformation['destination']) ,
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
                          MaterialPageRoute(builder: (context)=> const Homepage(navigateBool: false)));
                          dropOffBooking();
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
                        label: const Text(
                          'Drop Off',
                          style: TextStyle(color: Colors.white),
                        ),
            )),
            ],
          );
  }
}