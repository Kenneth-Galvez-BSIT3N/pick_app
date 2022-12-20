import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pick_app/pages/book_page/book_page.dart';
import 'package:pick_app/pages/navigate_page/navigate_page.dart';
import 'package:pick_app/pages/view_book_page/view_book_page.dart';

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
  void getUserBookings(){
    FirebaseFirestore.instance
    .collection('bookings')
    .where('status', isEqualTo: 'searching')
    .get()
    .then((value) => {
      print('Bookings Result: '),
        for (var element in value.docs) { 
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
    return Container(
      margin: const EdgeInsets.only(top:10,left: 20, right: 20),
      child:
      widget.userDetails['user_type'] == 'user' ?
      Container(
        child: widget.userDetails['on_book'] == false ?       
        ListView(
            children:  [
              ListTile(
                title: widget.source == '' ? const Text('Source location') : Text(widget.source),
                leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01)),
                onTap: (){},
              ),
              ListTile(
                title: widget.destination == '' ? const Text('Destination') : Text(widget.destination),
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
                          MaterialPageRoute(builder: (context)=> const NavigatePage()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
                        label: const Text(
                          'Select Location',
                          style: TextStyle(color: Colors.white),
                        ),
            )),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                            context, 
                          MaterialPageRoute(builder: (context)=> const BookPage()));
                  // Respond to button press
              },
              icon: const Icon(Icons.book_rounded, size: 18),
              label: const Text("Want to escape hassle? Book your rider here"),
            )
            ],
          )
          :
          ListView(
            children: [
              ListTile(
                title: const Text('Pickup Location'),
                leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01)),
                onTap: (){},
              ),
              ListTile(
                title: const Text('Destination Location'),
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
          ),
      )
      
          : 
          Container(
            child: widget.userDetails['on_book'] == false ?
            Expanded(child: 
            ListView(
                children: [
                  for(var element in userBooking)
                    ListTile(
                      title: Text(element.data()['fullname']),
                      leading: const Icon(Icons.location_pin, color: Colors.yellow),
                      onTap: (){
                        Navigator.push(
                              context, 
                            MaterialPageRoute(builder: (context)=> ViewBookPage(details: element.data(),id: element.id,)));
                      },  
                    ),
                ],
              )
            )
            :
          ListView(
            children:[
              ListTile(
                title: widget.source == '' ? const Text('Source location') : Text(widget.source),
                leading: const Icon(Icons.location_pin, color: Color(0xffE1AD01)),
                onTap: (){},
              ),
              ListTile(
                title: widget.destination == '' ? const Text('Destination') : Text(widget.destination),
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
                          MaterialPageRoute(builder: (context)=> const NavigatePage()));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffE1AD01)),
                        label: const Text(
                          'Select Location',
                          style: TextStyle(color: Colors.white),
                        ),
            )),
            ],
          ),
          )
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