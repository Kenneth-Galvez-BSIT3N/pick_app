import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pick_app/constants.dart';
import 'package:pick_app/widgets/core/drawer/drawer.dart';
import 'package:pick_app/widgets/core/panel_widget/panel_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


import '../login/login.dart';

// class GetUserName extends StatelessWidget {
//   final String documentId;

//   GetUserName(this.documentId);

//   @override
//   Widget build(BuildContext context) {
//     CollectionReference users = FirebaseFirestore.instance.collection('users');

//     return FutureBuilder<DocumentSnapshot>(
//       future: users.doc(documentId).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }

//         if (snapshot.hasData && !snapshot.data!.exists) {
//           return Text("Document does not exist");
//         }

//         if (snapshot.connectionState == ConnectionState.done) {
//           Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//           return Text("Full Name: ${data['full_name']} ${data['email']}");
//         }

//         return Text("loading");
//       },
//     );
//   }
// }

class Homepage extends StatefulWidget {
  final bool navigateBool;
  final LatLng pickUpCoord;
  final LatLng destinationCoord;
  final String sourceNavigate;
  final String destinationNavigate;
  final String? displayName;
  final String? email;
  final String? photoUrl;
  final String? uid;
  final LatLng partnerCoord;

  const Homepage({Key? key, 
  required this.navigateBool, 
  this.pickUpCoord = const LatLng(14.8527,120.8160), 
  this.destinationCoord = const LatLng(14.000000,121.000000), 
  this.sourceNavigate = '',
  this.destinationNavigate = '', 
  this.displayName = '', 
  this.email = '', 
  this.uid = '',
  this.photoUrl = "https://ui-avatars.com/api/?name=Bogart+Bardagul",
  this.partnerCoord = const LatLng(14.8527,120.8160)
  }) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}


class _HomepageState extends State<Homepage> {
  final Completer<GoogleMapController> _controler = Completer();
  late GoogleMapController googleMapController;
  // static const LatLng sourceLocation = LatLng(14.8409943, 120.8596824);
  // static const LatLng partnerLocation = LatLng(14.8580442, 120.8572516);
  // static const LatLng destination = LatLng(14.54349, 120.996941);
  double latitude = 14.8527;
  double longitude = 120.8160;
  late LocationPermission permission;
  Map userDetails = {};
  List<LatLng> polylineCoordinates = [];
  final FirebaseAuth auth = FirebaseAuth.instance;
  Map bookStatus = {};

  void getCurrentLocation() async {
    permission = await Geolocator.requestPermission();
    Timer.periodic(const Duration(seconds: 2), (timer)async { 
      var position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      var lastPosition = await Geolocator.getLastKnownPosition();
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
    
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      // PointLatLng(latitude, longitude), 
      PointLatLng(widget.pickUpCoord.latitude, widget.pickUpCoord.longitude), 
      PointLatLng(widget.destinationCoord.latitude, widget.destinationCoord.longitude));

      if(result.points.isNotEmpty){
        result.points.forEach(
          (PointLatLng point)=> 
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
          setState(() {
            
          });
      }
  }

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
  BitmapDescriptor partnerLocationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64,64)), "assets/Pin_source.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64,64)), "assets/Pin_destination.png")
        .then(
      (icon) {
        destinationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(64,64)), "assets/Badge.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  void Logout() async{
    await FirebaseAuth.instance.signOut();
    Navigator.push(context, MaterialPageRoute(builder:((context) => const Login())));
  }

  void getUserData(){
    FirebaseFirestore.instance
    .collection('users')
    .where('uid', isEqualTo: widget.uid)
    .get()
    .then((value) => {
      setState(() {
         userDetails = {
        'user_type':value.docs[0].data()['user_type'],
        'on_book': value.docs[0].data()['on_book'],
      };
      })
    });
  }

  void getBookStatus(){
    FirebaseFirestore.instance
    .collection('users')
    .doc(auth.currentUser?.uid.toString())
    .get()
    .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.data()}');
          setState(() {
            bookStatus = documentSnapshot.data() as Map;
          });
      } else {
        print('Document does not exist on the database');
      }
    });
  }
  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    print(widget.destinationCoord);
    print(widget.pickUpCoord);
    getUserData();
    getBookStatus();
    // setCustomMarkerIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      title: "Home Page",
      home: Scaffold(
        
        appBar: AppBar(
          title: const Text('Map'),
          actions: [
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                PopupMenuItem(
                  child: ListTile(
                    onTap: () => Logout(),
                    leading: TextButton.icon(
                    onPressed: () {
                       Logout();
                    },
                    icon: const Icon(Icons.logout, color: Colors.black),
                    label: const Text(""),
                  ),
                    title: const Text('Logout'),
                  ),
                ),
              ],
            ),
          ],
          backgroundColor: const Color(0xffE1AD01),
        ),
        drawer: DrawerWidget(displayName: widget.displayName,email: widget.email,),
        body: SlidingUpPanel(
          minHeight: MediaQuery.of(context).size.height*0.25,
          maxHeight: MediaQuery.of(context).size.height*0.4,
          body: GoogleMap(initialCameraPosition: CameraPosition(target: widget.pickUpCoord.latitude == 14.8527 ? LatLng(latitude,longitude) : widget.pickUpCoord, zoom: 18),
        polylines:{
          Polyline(polylineId: const PolylineId("route"), points: polylineCoordinates, color: Colors.blue, width: 11, visible: bookStatus['on_book'])
        },
        markers: {
      
           Marker(
        markerId: const MarkerId("currentLocation"),
        icon: currentLocationIcon,
        position: LatLng(latitude,longitude),
      ),
      Marker(
        markerId: const MarkerId("partnerLocation"),
        icon: partnerLocationIcon,
        position: widget.partnerCoord,
        visible: widget.partnerCoord.latitude == 14.8527 ? false : true
      ),
        Marker(
        markerId: const MarkerId("source"),
        icon: sourceIcon,
        position: widget.pickUpCoord,
        visible: widget.pickUpCoord.latitude == 14.8527 ? false : true
      ),
        Marker(
        markerId: const MarkerId("destination"),
        icon: destinationIcon,
        position: widget.destinationCoord,
        visible: widget.destinationCoord.latitude == 14.000000 ? false : true
      ),
        },
        onMapCreated: (GoogleMapController controller){
          googleMapController = controller;
        },
        ),
        panelBuilder: (controller) => PanelWidget(controller: controller, source:widget.sourceNavigate,destination:widget.destinationNavigate, userDetails: userDetails),
        ),
        floatingActionButton: Container(child: TextButton.icon(onPressed: () async{
          Position position = await _determinePosition();
          googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(position.latitude,position.longitude), zoom: 18)));
          setState(() {
            
          });
        }, icon: const Icon(Icons.add_location_outlined, size:32, color: Colors.black,), label: const Text('')), margin: EdgeInsets.only(top: MediaQuery.of(context).size.height*0.1),),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      ),
    );
  }

  Future<Position> _determinePosition() async{
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled){
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();

      if(permission == LocationPermission.denied){
        return Future.error('Location permission denied');
      }
    }

    if(permission == LocationPermission.deniedForever){
      return Future.error('Location permission are permanently denied.');
    }

    Position position = await Geolocator.getCurrentPosition();

    return position;
  }
}