import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//home page containing manage category, manage product, manage order, manage user

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('By Grocery Admin Panel'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/managecategory');
              },
              child: const Text('Manage Category'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageproduct');
              },
              child: const Text('Manage Product'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageorder');
              },
              child: const Text('Manage Order'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/manageuser');
              },
              child: const Text('Manage User'),
            ),
          ),
        ],
      ),
    );
  }
}
