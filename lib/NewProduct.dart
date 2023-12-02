import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewProduct extends StatefulWidget {
  const NewProduct({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NewProductState createState() => _NewProductState();
}

class _NewProductState extends State<NewProduct> {
  final _formKey = GlobalKey<FormState>();
  final _productNameController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productOldPriceController = TextEditingController();
  final _productNewPriceController = TextEditingController();
  final _productCategoryController = TextEditingController();
  final _productImageController = TextEditingController();
  final _productRateController = TextEditingController();
  final _productInstockController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
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
                    decoration: const InputDecoration(
                      labelText: 'Product Name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Name is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //description
                    controller: _productDescriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Product Description',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Product Description is required';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //oldprice
                    controller: _productOldPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Old Price',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter Product Old Price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //new price
                    controller: _productNewPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Product New Price',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter product New Price';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //category
                    controller: _productCategoryController,
                    decoration: const InputDecoration(
                      labelText: 'Product Category',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
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
                          'productOldPrice': _productOldPriceController.text,
                          'productNewPrice': _productNewPriceController.text,
                          'productCategory': _productCategoryController.text,
                          'productImage': _productImageController.text,
                          'productRate': _productRateController.text,
                          'productInstock': _productInstockController.text,
                        });
                        _productNameController.clear();
                        _productDescriptionController.clear();
                      }
                    },
                    child: const Text('Add Product'),
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
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot product = snapshot.data!.docs[index];

                    return ListTile(
                      title: Text(product['productName']),
                      subtitle: Text(product['productDescription']),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
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
