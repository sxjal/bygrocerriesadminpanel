import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);

  Future<Map<String, dynamic>> getOrderDetails() async {
    DatabaseReference dbRef =
        FirebaseDatabase.instance.ref().child('orders').child(orderId);
    // ignore: unused_element
    Map<String, dynamic> getOrderDetailsFromSnapshot(DataSnapshot snapshot) {
      return snapshot.value != null
          ? Map<String, dynamic>.from(snapshot.value)
          : {};
    }

    return Map<String, dynamic>.from(snapshot.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details: $orderId'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getOrderDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return ListView(
              children: <Widget>[
                ListTile(
                  title: Text('Name: ${snapshot.data?['name']}'),
                ),
                ListTile(
                  title: Text('Address: ${snapshot.data?['address']}'),
                ),
                ListTile(
                  title: Text('Items: ${snapshot.data?['Items']}'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
