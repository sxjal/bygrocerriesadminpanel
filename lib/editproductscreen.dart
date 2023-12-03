import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final String categoryId;

  const EditProductScreen({
    Key? key,
    required this.productId,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  // Add more controllers for other fields

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    // Initialize more controllers for other fields
    _loadProductData();
  }

  Future<void> _loadProductData() async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection(widget.categoryId)
        .doc(widget.productId)
        .get();

    if (productSnapshot.exists) {
      Map<String, dynamic> data =
          productSnapshot.data() as Map<String, dynamic>;
      _nameController.text = data['productName'];
      _descriptionController.text = data['productDescription'];
      _priceController.text = data['productPrice'].toString();
      // Set the text of more controllers with the corresponding data
    }
  }

  Future<void> _updateProductData() async {
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection(widget.categoryId)
        .doc(widget.productId)
        .update({
      'productName': _nameController.text,
      'productDescription': _descriptionController.text,
      'productPrice': double.parse(_priceController.text),
      // Update more fields with the text of the corresponding controllers
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Product Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Product Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a product price';
                  }
                  return null;
                },
              ),
              // Add more TextFormField widgets for other fields
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProductData();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
