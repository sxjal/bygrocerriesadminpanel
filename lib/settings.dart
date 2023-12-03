import 'package:bygrocerriesadminpanel/manageproducts.dart';
import 'package:bygrocerriesadminpanel/newproduct.dart';
import 'package:bygrocerriesadminpanel/addcategory.dart';
import 'package:bygrocerriesadminpanel/managecategory.dart';
import 'package:bygrocerriesadminpanel/settingscard.dart';
import 'package:flutter/material.dart';

//import 'package:cloud_firestore/cloud_firestore.dart';
//home page containing manage category, manage product, manage order, manage user
// ignore: must_be_immutable

// ignore: must_be_immutable
class Settings extends StatelessWidget {
  int currentPageIndex = 0;

  Settings({super.key});

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
                        builder: (context) => ManageProductsScreen(),
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
          ],
        ),
      ),
    );
  }
}
