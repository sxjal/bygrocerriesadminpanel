import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

//name
//id
//category
//description
//image
//old price
//price
//rate
//instock

class _AdminPanelState extends State<AdminPanel> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _productNameController,
                    decoration: InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _productDescriptionController,
                    decoration:
                        InputDecoration(labelText: 'Product Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _productDescriptionController,
                    decoration: InputDecoration(labelText: 'Old Price'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Old Price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _productDescriptionController,
                    decoration: InputDecoration(labelText: 'Product New Price'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product New Price';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        FirebaseFirestore.instance.collection('products').add({
                          'productName': _productNameController.text,
                          'productDescription':
                              _productDescriptionController.text,
                        });
                        _productNameController.clear();
                        _productDescriptionController.clear();
                      }
                    },
                    child: Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot product = snapshot.data!.docs[index];

                    return ListTile(
                      title: Text(product['productName']),
                      subtitle: Text(product['productDescription']),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('products')
                              .doc(product.id)
                              .delete();
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
