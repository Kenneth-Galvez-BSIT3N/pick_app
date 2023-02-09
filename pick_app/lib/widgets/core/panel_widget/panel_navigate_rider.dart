import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../pages/view_book_page/view_book_page.dart';

class PanelNavigateRider extends StatefulWidget {
  const PanelNavigateRider({Key? key}) : super(key: key);

  @override
  State<PanelNavigateRider> createState() => _PanelNavigateRiderState();
}

class _PanelNavigateRiderState extends State<PanelNavigateRider> {
  List userBooking = [];

  void getUserBookings() {
    FirebaseFirestore.instance
        .collection('bookings')
        .where('status', isEqualTo: 'searching')
        .get()
        .then((QuerySnapshot value) => {
              for (var element in value.docs)
                {
                  setState(() {
                    userBooking.add(element);
                  })
                }
            });
  }

  @override
  void initState() {
    getUserBookings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const ListTile(
          title: Center(
            child: Text('Booking List',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        for (var element in userBooking)
          ListTile(
            title: Text(element.data()['fullname']),
            leading: const Icon(Icons.location_pin, color: Colors.yellow),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewBookPage(
                            details: element.data(),
                            id: element.id,
                          )));
            },
          ),
      ],
    );
  }
}
