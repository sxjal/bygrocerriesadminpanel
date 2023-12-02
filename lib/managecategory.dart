import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageCategory extends StatefulWidget {
  const ManageCategory({super.key});

  @override
  State<ManageCategory> createState() => _ManageCategoryState();
}

class _ManageCategoryState extends State<ManageCategory> {
  List<dynamic> categories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Category'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!(snapshot.hasData)) {
            return const Text("No Data found, please add some data");
          }

          categories = snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            return data['categoryName'];
          }).toList();

          return categories.isNotEmpty
              ? ListView(
                  children: categories
                      .map((e) => ListTile(
                            title: Text(e),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () async {
                                    // Update category name
                                    TextEditingController controller =
                                        TextEditingController(text: e);
                                    String newName = await showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Update Category Name'),
                                            content: TextField(
                                              controller: controller,
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      "Enter new category name"),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Update'),
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(controller.text);
                                                },
                                              ),
                                            ],
                                          ),
                                        ) ??
                                        "";

                                    if (newName.isNotEmpty) {
                                      // Fetch the document with the old category name
                                      var querySnapshot =
                                          await FirebaseFirestore.instance
                                              .collection('categories')
                                              .where('categoryName',
                                                  isEqualTo: e)
                                              .get();

                                      // Update the category name in each matching document
                                      for (var doc in querySnapshot.docs) {
                                        doc.reference
                                            .update({'categoryName': newName});
                                      }
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    // Fetch the document with the category name
                                    var querySnapshot = await FirebaseFirestore
                                        .instance
                                        .collection('categories')
                                        .where('categoryName', isEqualTo: e)
                                        .get();

                                    // Delete each matching document
                                    for (var doc in querySnapshot.docs) {
                                      doc.reference.delete();
                                    }
                                  },
                                ),
                              ],
                            ),
                          ))
                      .toList(),
                )
              : const Center(
                  child: Text("No Categories Found, Add few!"),
                );
        },
      ),
    );
  }
}
