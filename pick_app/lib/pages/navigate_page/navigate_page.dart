// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment, prefer_final_fields, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:google_place/google_place.dart';
import 'package:pick_app/pages/homepage/homepage.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class AddressObject {
  late String _SourceLocation;
  late String _DestinationLocation;

  void _SET_SOURCE_LOCATION(String _SourceLocation){
    this._SourceLocation = _SourceLocation;
  }
   void _SET_DESTINATION_LOCATION(String _DestinationLocation){
    this._DestinationLocation = _DestinationLocation;
  }

  String GET_SOURCE_LOCATION(){
    return _SourceLocation;
  }
  String GET_DESTINATION_LOCATION(){
    return _DestinationLocation;
  }
}
class NavigatePage extends StatefulWidget {
  const NavigatePage({Key? key}) : super(key: key);

  @override
  State<NavigatePage> createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  AddressObject addressObject = new AddressObject();
  late bool controllervalue;
  TextEditingController _sourceLocation = TextEditingController();
  TextEditingController _destination = TextEditingController();
  late LatLng _pickUpCoord;
  late LatLng _destinationCoord;

  var uuid  = const Uuid();
  String _sessionToken = '122344';
  List<dynamic> _placeList = [];

  @override
  void initState() {
    super.initState();

    _sourceLocation.addListener(() {
      onChangeSource();
    });

    _destination.addListener(() {
      onChangeDestination();
    });
  }

  void onChangeSource(){
    if(_sessionToken == null){
      _sessionToken = uuid.v4();
    }
    controllervalue = true;
    getSuggestion(_sourceLocation.text);
  }

  void onChangeDestination(){
    if(_sessionToken == null){
      _sessionToken = uuid.v4();
    }
    controllervalue = false;
    getSuggestion(_destination.text);
  }

  void getSuggestion(String input)async{
    String kPLACES_API_KEY = 'AIzaSyBFXJES_kQ6-_s7ZbH2sx0-FanKWLqyux0';
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
     String request = '$baseURL?input=$input&key=$kPLACES_API_KEY&sessiontoken=$_sessionToken';

     var response = await http.get(Uri.parse(request));
     var data = jsonDecode(response.body.toString());
     if(response.statusCode == 200){
      setState(() {
        _placeList = jsonDecode(response.body.toString()) ['predictions'];
      });
     }
     else{
      throw Exception('Failed to load data');
     }
  }

  void getLatLongPickUp(address) async{
     List<Location> locations = await locationFromAddress(address);
     _pickUpCoord = LatLng(locations.last.latitude.toDouble(), locations.last.longitude.toDouble());
  }
  void getLatLongDestination(address) async{
     List<Location> locations = await locationFromAddress(address);
     _destinationCoord = LatLng(locations.last.latitude.toDouble(), locations.last.longitude.toDouble());
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
          controller: _sourceLocation,
          decoration: const InputDecoration(
            hintText: "Current Location",
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.location_pin, color: Colors.yellow,)
          ),
        ),

        const SizedBox(height: 50,
        child: Icon(Icons.arrow_downward),),
        TextFormField(
            controller: _destination,
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
              child: ListView.builder(itemCount: _placeList.length,itemBuilder: (context,index){
                return ListTile(
                title: Text(_placeList[index]['description']),
                leading: const Icon(Icons.location_pin),
                onTap: (){
                 
                  setState(() {
                    if(controllervalue){
                      _sourceLocation.text = _placeList[index]['description'];
                      getLatLongPickUp(_placeList[index]['description']);
                      addressObject._SET_SOURCE_LOCATION(_placeList[index]['description']);
                    }
                    else{
                      _destination.text = _placeList[index]['description'];
                      getLatLongDestination(_placeList[index]['description']);
                      addressObject._SET_DESTINATION_LOCATION(_placeList[index]['description']);
                    }
                    
                  });
                },
              );
              })
                ),
  ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 50,
          child: ElevatedButton.icon(
                        icon: const Icon(Icons.directions, color:Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> Homepage(
                            navigateBool: true,
                            pickUpCoord: _pickUpCoord,
                            destinationCoord: _destinationCoord, 
                            sourceNavigate: addressObject.GET_SOURCE_LOCATION(),
                            destinationNavigate:addressObject.GET_DESTINATION_LOCATION())));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
                        label: const Text(
                          'Navigate this Location',
                          style: TextStyle(color: Colors.white),
                        ),
            )),
          
      ]),
    ));
  }
}