import 'package:flutter/material.dart';

class HistoryDetails extends StatefulWidget {
  const HistoryDetails({Key? key}) : super(key: key);

  @override
  State<HistoryDetails> createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: const Color(0xffE1AD01),),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [

                const Text('Origin: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                const Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry', maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,),
                const SizedBox(height: 10,),
                const Text('Destination: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                const Text('Lorem Ipsum is simply dummy text of the printing and typesetting industry', maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify,),
                const SizedBox(height: 50,),
                const Text('Date and Time of Booking'),
                const SizedBox(height: 10,),
                const Text('Date and Time of Arrival'),
                const SizedBox(height: 50,),
                Row(
                  children:const  [
                    Text('Total Price: '),
                    Text('₱00.00', style: TextStyle(fontSize: 24,),),
                ]),

          ],
        ),
      ),
    );
  }
}