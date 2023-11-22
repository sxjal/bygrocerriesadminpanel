import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

//home page containing manage category, manage product, manage order, manage user

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                left: MediaQuery.of(context).size.height * 0.01,
                bottom: MediaQuery.of(context).size.height * 0.01,
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
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 204, 20, 20),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(188, 195, 3, 179),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.manage_search,
                          size: 70,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        const Text(
                          "Manage Products",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(174, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 72, 72, 72),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(189, 3, 112, 195),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_shopping_cart,
                          size: 70,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        const Text(
                          "Add New Product",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(174, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 19, 19, 19),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(187, 3, 195, 99),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.manage_history_outlined,
                          size: 70,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        const Text(
                          "Manage Categories",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(174, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => {},
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.width * 0.45,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 72, 72, 72),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(189, 3, 112, 195),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.add_shopping_cart,
                          size: 70,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        const Text(
                          "Add New Category",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(174, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
