import 'package:bygrocerriesadminpanel/manageproducts.dart';
import 'package:bygrocerriesadminpanel/newproduct.dart';
import 'package:bygrocerriesadminpanel/addcategory.dart';
import 'package:bygrocerriesadminpanel/managecategory.dart';
import 'package:bygrocerriesadminpanel/settingscard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
//home page containing manage category, manage product, manage order, manage user
// ignore: must_be_immutable

// ignore: must_be_immutable
class Settings extends StatefulWidget {
  Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  int currentPageIndex = 0;
  bool _isEditing = false;
  final shippingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(10),
        //margin: const EdgeInsets.all(10),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
                left: MediaQuery.of(context).size.height * 0.0,
                bottom: MediaQuery.of(context).size.height * 0.02,
              ),
              child: const Text(
                "Welcome Back, Kunal!",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            //implement orders section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                SettingsCard(
                  cardIcon: Icons.manage_search,
                  text: "Add Product",
                  color: const Color.fromARGB(188, 195, 3, 179),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewProduct(),
                      ),
                    ),
                  },
                ),
                SettingsCard(
                  cardIcon: Icons.manage_search,
                  text: "Add Category",
                  color: const Color.fromARGB(187, 83, 3, 195),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddCategory(),
                      ),
                    ),
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                SettingsCard(
                  cardIcon: Icons.manage_history_outlined,
                  text: "Manage Prdoucts",
                  color: const Color.fromARGB(187, 3, 147, 195),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageProductsScreen(),
                      ),
                    ),
                  },
                ),
                SettingsCard(
                  cardIcon: Icons.manage_history_outlined,
                  text: "Manage Categories",
                  color: const Color.fromARGB(187, 3, 195, 150),
                  onTap: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ManageCategory(),
                      ),
                    ),
                  },
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('adminvariables')
                  .doc('kAvueqh83Ux8bi9CA0bQ')
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                //print(snapshot.data!.data()!['deliveryFee']);
                if (snapshot.hasError) {
                  return const Text("Something went wrong");
                }

                if (snapshot.hasData && !snapshot.data!.exists) {
                  return const Text("Document does not exist");
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  Map<String, dynamic> data =
                      snapshot.data!.data() as Map<String, dynamic>;
                  shippingController.text = data['deliveryFee'].toString();
                  return Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: shippingController,
                          decoration: const InputDecoration(
                            labelText: 'Shipping',
                          ),
                          enabled: _isEditing,
                        ),
                      ),
                      IconButton(
                        icon: Icon(_isEditing ? Icons.check : Icons.edit),
                        onPressed: () {
                          if (_isEditing) {
                            FirebaseFirestore.instance
                                .collection('adminvariables')
                                .doc('kAvueqh83Ux8bi9CA0bQ')
                                .update({
                              'deliveryFee': int.parse(shippingController.text),
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Shipping value updated'),
                              ),
                            );
                          }
                          ;

                          setState(() {
                            _isEditing = !_isEditing;
                          });
                        },
                      ),
                    ],
                  );
                }

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
