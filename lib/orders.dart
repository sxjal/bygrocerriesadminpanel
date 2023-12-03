import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrdersScreen extends StatelessWidget {
  OrdersScreen({super.key});

  final databaseReference = FirebaseDatabase.instance.ref();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Orders'),
      ),
      body: FutureBuilder<DatabaseEvent>(
        future: databaseReference.child('orders').once(),
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
                return ListView.builder(
                  itemCount: values.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text('Order ${i + 1}'),
                    subtitle: Text(
                        'Details: ${values.values.elementAt(i).toString()}'),
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
