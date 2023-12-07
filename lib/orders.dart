import 'package:bygrocerriesadminpanel/orderdetailspage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.topLeft,
          child: Text(
            'Orders',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: databaseReference.child('orders').onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Map<dynamic, dynamic>? values =
                  snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
              if (values == null) {
                return Container(); // or return a widget to indicate no orders
              } else {
                return Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: values.length,
                    itemBuilder: (ctx, i) {
                      var keys = values.keys.toList()
                        ..sort((a, b) => b.compareTo(a));
                      var order = values[keys[i]];
                      var status = order['Status'];
                      status = "CLOSED";
                      Color color = Colors.orange;
                      if (status == "OPEN") {
                        color = const Color.fromARGB(255, 255, 182, 64);
                      } else if (status == "CLOSED") {
                        color = Colors.green;
                      } else if (status == "RETURNED") {
                        color = Colors.red;
                      } // Assuming the status is stored in a 'status' field
                      var orderId = keys[i];
                      var date = order['Date'];
                      var amount = order['amount'];
                      var time = order['Time'];
                      var visibleOrderId =
                          orderId.substring(orderId.length - 4);
                      var greyOrderId =
                          orderId.substring(0, orderId.length - 4);

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              10), // Set the border radius
                        ),
                        color: const Color.fromARGB(255, 255, 255, 255),
                        elevation: 10,
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        OrderDetailsPage(order: order),
                                  ),
                                );
                              },
                              title: Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: 'ID: ',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 14,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: greyOrderId,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            color:
                                                Color.fromARGB(255, 85, 85, 85),
                                          ),
                                        ),
                                        TextSpan(
                                          text: visibleOrderId,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Spacer(),
                                  const Icon(
                                    Icons.currency_rupee,
                                    size: 14,
                                    // weight: 50,
                                  ),
                                  Text(
                                    amount.toString(),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 70, 70, 70),
                                    ),
                                  ),
                                ],
                              ),
                              // subtitle: Text(
                              //     'Items: ${order['Items'].entries.map((e) => '${e.key}: ${e.value}').join(', ')}'),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  margin: const EdgeInsets.all(10.0),
                                  child: Text(
                                    '$time | $date',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 21, 21, 21),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  margin: const EdgeInsets.only(
                                    right: 10.0,
                                    bottom: 10.0,
                                  ),
                                  padding: const EdgeInsets.only(
                                    top: 4.0,
                                    bottom: 4.0,
                                    left: 10.0,
                                    right: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    status,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
