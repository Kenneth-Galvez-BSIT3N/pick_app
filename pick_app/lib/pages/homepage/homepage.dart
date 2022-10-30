import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pick_app/constants.dart';
import 'package:pick_app/widgets/core/drawer/drawer.dart';
import 'package:pick_app/widgets/core/panel_widget/panel_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../login/login.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final Completer<GoogleMapController> _controler = Completer();
  static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
  static const LatLng destination = LatLng(37.33429383, -122.06600055);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      google_api_key, 
      PointLatLng(sourceLocation.latitude, sourceLocation.longitude), 
      PointLatLng(destination.latitude, destination.longitude));

      if(result.points.isNotEmpty){
        result.points.forEach(
          (PointLatLng point)=> 
          polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
          setState(() {
            
          });
      }
  }

  @override
  void initState() {
    // TODO: implement initState
    getPolyPoints();
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
                    leading: TextButton.icon(
                    onPressed: () {
                       Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const Login()));
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
        drawer: const DrawerWidget(),
        body: SlidingUpPanel(
          minHeight: MediaQuery.of(context).size.height*0.25,
          maxHeight: MediaQuery.of(context).size.height*0.4,
          body: GoogleMap(initialCameraPosition: const CameraPosition(target: sourceLocation, zoom: 13.5),
        polylines: {
          Polyline(polylineId: PolylineId("route"), points: polylineCoordinates, color: Colors.blue, width: 6)
        },
        markers: {
          const Marker(markerId: MarkerId('source'), position:sourceLocation),
          const Marker(markerId: MarkerId('destination'), position:destination),
        },),
        panelBuilder: (controller) => PanelWidget(controller: controller),
        ),
      ),
    );
  }
}