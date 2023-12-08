import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<Object?, Object?> order;
  final String orderId;

  const OrderDetailsPage({Key? key, required this.order, required this.orderId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order ID # ${orderId.substring(orderId.length - 4)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          elevation: 5,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Order ID: $orderId',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${order['Date']}, ${order['Time']}',
                  style: const TextStyle(fontSize: 14),
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 10),
                Text(
                  'User Name: ${order['userName']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Address: ${order['address']}',
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  'Items: ${order['Items']}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
