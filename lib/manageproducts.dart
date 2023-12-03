import 'package:bygrocerriesadminpanel/editproductscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Products'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .orderBy('categoryName')
            .snapshots(),
        //   stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['categoryName']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductList(categoryId: document.id),
                    ),
                  );
                },
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ProductList extends StatelessWidget {
  final String categoryId;

  Future<String> getCategoryName(String categoryId) async {
    DocumentSnapshot categorySnapshot = await FirebaseFirestore.instance
        .collection('categories')
        .doc(categoryId)
        .get();

    if (categorySnapshot.exists) {
      Map<String, dynamic> data =
          categorySnapshot.data() as Map<String, dynamic>;
      return data['categoryName'];
    } else {
      throw Exception('Category not found');
    }
  }

  const ProductList({super.key, required this.categoryId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('categories')
            .doc(categoryId)
            .get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          String categoryName = data['categoryName'];

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('categories')
                .doc(categoryId)
                .collection(categoryName)
                .orderBy("productName")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> productSnapshot) {
              if (productSnapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (productSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                children:
                    productSnapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> productData =
                      document.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(productData['productName']),
                    subtitle: Text(productData['productDescription']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProductScreen(
                            productId: document.id,
                            categoryId: categoryId,
                            category: categoryName,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          );
        },
      ),
    );
  }
}
