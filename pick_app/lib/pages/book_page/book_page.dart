// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_place/google_place.dart';
import 'package:pick_app/pages/homepage/homepage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

//firebase import
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddressObject {
  late String _SourceLocation;
  late String _DestinationLocation;

  void _SET_SOURCE_LOCATION(String _SourceLocation) {
    this._SourceLocation = _SourceLocation;
  }

  void _SET_DESTINATION_LOCATION(String _DestinationLocation) {
    this._DestinationLocation = _DestinationLocation;
  }

  String GET_SOURCE_LOCATION() {
    return _SourceLocation;
  }

  String GET_DESTINATION_LOCATION() {
    return _DestinationLocation;
  }
}

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  // late GooglePlace googlePlace;
  AddressObject addressObject = new AddressObject();
  late bool controllervalue;
  TextEditingController _sourceLocation = TextEditingController();
  TextEditingController _destination = TextEditingController();

  FirebaseFirestore firestoreInstance =
      FirebaseFirestore.instance; //Firestore instantiation
  final FirebaseAuth auth = FirebaseAuth.instance; //Auth instance

  var _price = "₱00.00";
  late LatLng _pickUpCoord;
  late LatLng _destinationCoord;

  var uuid = const Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _sourceLocation.addListener(() {
      onChangeSource();
    });

    _destination.addListener(() {
      onChangeDestination();
    });

    // String apiKey = 'AIzaSyBFXJES_kQ6-_s7ZbH2sx0-FanKWLqyux0';
    // googlePlace = GooglePlace(apiKey);
  }

  void onChangeSource() {
    if (_sessionToken == null) {
      _sessionToken = uuid.v4();
    }
    controllervalue = true;
    getSuggestion(_sourceLocation.text);
  }

  void onChangeDestination() {
    if (_sessionToken == null) {
      _sessionToken = uuid.v4();
    }
    controllervalue = false;
    getSuggestion(_destination.text);
  }

  void getSuggestion(String input) async {
    String kPLACES_API_KEY = 'AIzaSyBYV4yr3PPXPQRjpXyteABsLRedyOVmdOo';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request =
        '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

    var response = await http.get(Uri.parse(request));
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      setState(() {
        _placeList = jsonDecode(response.body.toString())['predictions'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  void getLatLongPickUp(address) async {
    List locations = await locationFromAddress(address);
    _pickUpCoord = LatLng(locations.last.latitude.toDouble(),
        locations.last.longitude.toDouble());
  }

  void getLatLongDestination(address) async {
    List locations = await locationFromAddress(address);
    _destinationCoord = LatLng(locations.last.latitude.toDouble(),
        locations.last.longitude.toDouble());
    var distance = Geolocator.distanceBetween(
        _pickUpCoord.latitude,
        _pickUpCoord.longitude,
        _destinationCoord.latitude,
        _destinationCoord.longitude);
    var remainder = (distance.toInt() / 1000) % 10;
    var price = ((distance.toInt() / 1000) * 20) + (remainder != 0 ? 10 : 0);
    setState(() {
      _price = "₱" + price.toInt().toString();
    });
  }

  Future<void> bookPage(
      pickup_location, destination, pickup_coord, destination_coord) {
    return firestoreInstance
        .collection("bookings")
        // .doc(auth.currentUser?.uid.toString())
        .add({
          'pickup_location': pickup_location,
          'destination': destination,
          'pickup_coord': {
            "latitude": pickup_coord.latitude,
            "longitude": pickup_coord.longitude
          },
          'destination_coord': {
            "latitude": destination_coord.latitude,
            "longitude": destination_coord.longitude
          },
          'status': 'searching',
          'fullname': auth.currentUser?.displayName,
          'phone_number': auth.currentUser?.phoneNumber,
          'uid': auth.currentUser?.uid.toString(),
          'price': _price,
          'description': '...',
          'rider_id': '',
        })
        .then((value) => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Homepage(
                          navigateBool: true,
                          pickUpCoord: pickup_coord,
                          destinationCoord: destination_coord,
                          sourceNavigate: pickup_location,
                          destinationNavigate: destination))),
            })
        .catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xffE1AD01)),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Column(children: [
            TextFormField(
              controller: _sourceLocation,
              decoration: const InputDecoration(
                  hintText: "Current Location",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.location_pin,
                    color: Color(0xffE1AD01),
                  )),
            ),
            const SizedBox(
              height: 50,
              child: Icon(Icons.arrow_downward),
            ),
            TextFormField(
              controller: _destination,
              decoration: const InputDecoration(
                hintText: "Destination",
                border: OutlineInputBorder(),
                prefixIcon: Icon(
                  Icons.flag,
                  color: Color(0xffE1AD01),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: SizedBox(
                  height: 42.0,
                  child: ListView.builder(
                      itemCount: _placeList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(_placeList[index]['description']),
                          leading: const Icon(Icons.location_pin),
                          onTap: () {
                            setState(() {
                              if (controllervalue) {
                                _sourceLocation.text =
                                    _placeList[index]['description'];
                                getLatLongPickUp(
                                    _placeList[index]['description']);
                                addressObject._SET_SOURCE_LOCATION(
                                    _placeList[index]['description']);
                              } else {
                                _destination.text =
                                    _placeList[index]['description'];
                                getLatLongDestination(
                                    _placeList[index]['description']);
                                addressObject._SET_DESTINATION_LOCATION(
                                    _placeList[index]['description']);
                              }
                            });
                          },
                        );
                      })),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(children: [
              const Text('Total Price: '),
              Text(
                _price,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ]),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.book),
                  onPressed: () => bookPage(
                    addressObject.GET_SOURCE_LOCATION(),
                    addressObject.GET_DESTINATION_LOCATION(),
                    _pickUpCoord,
                    _destinationCoord,
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffE1AD01)),
                  label: const Text(
                    'Book a Rider',
                    style: TextStyle(color: Colors.black),
                  ),
                )),
          ]),
        ));
  }
}
