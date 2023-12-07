import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<Object?, Object?> order;

  const OrderDetailsPage({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            'Order details: ${order.toString()}'), // Display the order details
      ),
    );
  }
}
