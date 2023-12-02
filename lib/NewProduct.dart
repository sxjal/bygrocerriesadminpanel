import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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

  String? _selectedCategory;
  bool _isSamePrice = true;
  File? _image;
  Future<File?> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    } else {
      print('No image selected');
      return null;
    }
  }

  Future<String?> uploadImage(File image) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child("product_images").child(fileName);
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() => null);
    return await ref.getDownloadURL();
  }
  //makje this a named parameter in the function alert

  void alert({String error = "Please select a Category and an Image"}) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content: Text(error),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ignore: no_leading_underscores_for_local_identifiers
  bool validate(GlobalKey<FormState> _formKey) {
    if (!(_formKey.currentState!.validate())) {
      return false;
    }
    if (_image == null) {
      alert();
      return false;
    }
    if (_selectedCategory == null) {
      alert();
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  List<DropdownMenuItem> categoryItems =
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    return DropdownMenuItem(
                      value: document.id,
                      child: Text(data['categoryName']),
                    );
                  }).toList();

                  return DropdownButtonFormField(
                    value: _selectedCategory,
                    items: categoryItems,
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value as String?;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Category',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  );
                },
              ),
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
                      CheckboxListTile(
                        title: const Text(
                            'Is the old price the same as the new price?'),
                        value: _isSamePrice,
                        onChanged: (bool? value) {
                          setState(() {
                            _isSamePrice = value!;
                            if (_isSamePrice) {
                              _productOldPriceController.text =
                                  _productNewPriceController.text;
                            }
                          });
                        },
                      ),
                      if (!_isSamePrice)
                        TextFormField(
                          controller: _productNewPriceController,
                          decoration: const InputDecoration(
                            labelText: 'New Price',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter new price';
                            }
                            return null;
                          },
                        ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      GestureDetector(
                        child: Container(
                          height: _image == null ? 100 : null,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                          ),
                          child: _image == null
                              ? const Center(child: Text('Pick Image'))
                              : Image.file(_image!), //Image.file(_image!),
                        ),
                        onTap: () async {
                          File? image = await pickImage();
                          if (image != null) {
                            setState(() {
                              _image = image;
                            });
                          }
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.02,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (validate(_formKey)) {
                            try {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: LinearProgressIndicator(),
                                  duration: Duration(
                                      hours:
                                          1), // Keep the SnackBar visible until manually dismissed
                                ),
                              );
                              String? imageUrl = await uploadImage(_image!);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar(); // Hide the SnackBar when the upload is complete
                              if (imageUrl != null) {
                                await FirebaseFirestore.instance
                                    .collection('products')
                                    .add(
                                  {
                                    'productName': _productNameController.text,
                                    'productDescription':
                                        _productDescriptionController.text,
                                    'productOldPrice':
                                        _productOldPriceController.text,
                                    'productNewPrice':
                                        _productNewPriceController.text,
                                    'productCategory': _selectedCategory,
                                    'productImage':
                                        _productImageController.text,
                                    'productRate': _productRateController.text,
                                    'productInstock': true,
                                  },
                                );

                                await FirebaseFirestore.instance
                                    .collection('categories')
                                    .doc(_selectedCategory)
                                    .collection("products")
                                    .add({
                                  'productName': _productNameController.text,
                                  'productDescription':
                                      _productDescriptionController.text,
                                  'oldPrice': _productOldPriceController.text,
                                  'newPrice': _productNewPriceController.text,
                                  'productImage': imageUrl,
                                  'productRate': _productRateController.text,
                                  'productInstock': true,
                                });
                              }
                            } catch (e) {
                              alert(error: e.toString());
                            }
                            _productNameController.clear();
                            _productDescriptionController.clear();
                            _productOldPriceController.clear();
                            _productNewPriceController.clear();
                            _productCategoryController.clear();
                            _productRateController.clear();

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Product Added'),
                                duration: Duration(seconds: 4),
                              ),
                            );
                            setState(() {
                              _selectedCategory = null;
                              _image = null;
                            });
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Text('Add Product'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
