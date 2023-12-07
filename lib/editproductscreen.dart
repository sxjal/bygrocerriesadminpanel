import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class EditProductScreen extends StatefulWidget {
  final String productId;
  final String categoryId;
  final String category;

  const EditProductScreen({
    Key? key,
    required this.productId,
    required this.categoryId,
    required this.category,
  }) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageController;
  late TextEditingController _inStockController;
  late TextEditingController _oldPriceController;
  late TextEditingController _rateController;
  // Add more controllers for other fields
  File? _image;
  bool _isImageChanged = false;
  bool _isSamePrice = true;
  bool _isInStock = true;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _descriptionController = TextEditingController();
    _priceController = TextEditingController();
    _imageController = TextEditingController();
    _inStockController = TextEditingController();
    _oldPriceController = TextEditingController();
    _rateController = TextEditingController();
    // Initialize more controllers for other fields
    _loadProductData();
  }

  Future<File?> pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      return File(image.path);
    } else {
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

  Future<void> _loadProductData() async {
    DocumentSnapshot productSnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection(widget.category)
        .doc(widget.productId)
        .get();

    if (productSnapshot.exists) {
      Map<String, dynamic> data =
          productSnapshot.data() as Map<String, dynamic>;
      _nameController.text = data['productName'];
      _descriptionController.text = data['productDescription'];
      _priceController.text = data['productPrice'].toString();
      _imageController.text = data['productImage'];
      _inStockController.text = data['productInstock'].toString();
      _oldPriceController.text = data['productOldPrice'].toString();
      _rateController.text = data['productRate'].toString();
      // Set the text of more controllers with the corresponding data
      _isSamePrice = data['productPrice'] == data['productOldPrice'];

      _isInStock = data['productInstock'];
    }
  }

  // ignore: no_leading_underscores_for_local_identifiers
  Future<void> _updateProductData(_image) async {
    final Completer<void> completer = Completer<void>();
    const SnackBar snackBar = SnackBar(
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(),
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text('Updating...'),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
    String? newurl;
    if (_isImageChanged) {
      newurl = await uploadImage(_image!);
    }
    await FirebaseFirestore.instance
        .collection('categories')
        .doc(widget.categoryId)
        .collection(widget.category)
        .doc(widget.productId)
        .update({
      'productName': _nameController.text,
      'productDescription': _descriptionController.text,
      'productPrice': double.parse(_priceController.text),
      'productImage': _isImageChanged ? newurl : _imageController.text,
      'productInstock': bool.parse(_isInStock.toString()),
      'productOldPrice': double.parse(_oldPriceController.text),
      'productRate': double.parse(_rateController.text),
      // Update more fields with the text of the corresponding controllers
    }).then((_) => completer.complete());
    await completer.future;
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
  }

  @override
  Widget build(BuildContext context) {
    _loadProductData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                ),
                child: _isImageChanged == false
                    ? (Uri.tryParse(_imageController.text)?.isAbsolute ?? false)
                        ? Image.network(_imageController.text)
                        : Container()
                    : Image.file(_image!), //Image.file(_image!),
              ),
              onTap: () async {
                File? image = await pickImage();
                if (image != null) {
                  setState(() {
                    _image = image;
                    _isImageChanged = true;
                  });
                }
              },
            ),
            SwitchListTile(
              title: const Text('Product In Stock'),
              value: _isInStock,
              onChanged: (bool value) {
                setState(() {
                  _isInStock = value;
                });
              },
            ),
            TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                onChanged: (value) => {
                      _nameController.text = value,
                    }),
            TextFormField(
              controller: _descriptionController,
              decoration:
                  const InputDecoration(labelText: 'Product Description'),
            ),
            TextFormField(
              controller: _oldPriceController,
              decoration: const InputDecoration(labelText: 'Product Price'),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(
              title:
                  const Text('Is the Discounted price same as the new price?'),
              value: _isSamePrice,
              onChanged: (bool? value) {
                setState(() {
                  _isSamePrice = value!;
                  if (_isSamePrice) {
                    _priceController.text = _oldPriceController.text;
                  }
                });
              },
            ),
            if (!_isSamePrice)
              TextFormField(
                controller: _priceController,
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
            TextFormField(
              controller: _rateController,
              decoration: const InputDecoration(labelText: 'Product Rate'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _updateProductData(_image);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update Product'),
            ),
          ],
        ),
      ),
    );
  }
}
