import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({Key? key}) : super(key: key);

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  final TextEditingController controller = TextEditingController();

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
    Reference ref = storage.ref().child("category_images").child(fileName);
    UploadTask uploadTask = ref.putFile(image);
    await uploadTask.whenComplete(() => null);
    return await ref.getDownloadURL();
  }

  File? _image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Category'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Enter category name",
                ),
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
                  if (_image == null || controller.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Error'),
                          content: const Text(
                              'Please Enter a valid name and upload an Image.'),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  } else {
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
                      //add a snackbar to show that the upload is complete
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Category Added'),
                        ),
                      );
                      Navigator.pop(context);
                      if (imageUrl != null) {
                        await FirebaseFirestore.instance
                            .collection('categories')
                            .add(
                          {
                            'categoryName': controller.text,
                            'categoryImage': imageUrl,
                          },
                        );
                      }
                    } catch (e) {
                      print('Failed to add category: $e');
                    }
                  }
                },
                child: const Text("Add Category"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
