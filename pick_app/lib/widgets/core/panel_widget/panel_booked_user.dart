import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PanelBookedUser extends StatefulWidget {
  final String uid;
  const PanelBookedUser({Key? key, required this.uid}) : super(key: key);

  @override
  State<PanelBookedUser> createState() => _PanelBookedUserState();
}

class _PanelBookedUserState extends State<PanelBookedUser> {

  Map bookingInformation = {};
  void getUserBooking(uid){
    FirebaseFirestore.instance
    .collection('bookings')
    .where('uid', isEqualTo: uid)
    .get()
    .then((value) => {
      for(final element in value.docs){
        if(element.data()['status'] == "ongoing"){
          setState((){
          bookingInformation = {
            'pickup_location': element.data()['pickup_location'],
            'destination': element.data()['destination']
          };
        })
        }
      }
      
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
            children: [
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
              ListTile(
                title: const LinearProgressIndicator(
                    semanticsLabel: 'Linear progress indicator',
                  ),
                leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01),),
                trailing: const Icon(Icons.flag, color: Colors.redAccent,),
                onTap: (){},
              ),
            ],
          );
  }
}