import 'package:flutter/material.dart';

import 'productlist.dart';

class OrderDetailsPage extends StatelessWidget {
  final Map<Object?, Object?> order;
  final String orderId;
  final String itemList;
  final String quantityList;

  const OrderDetailsPage(
      {Key? key,
      required this.order,
      required this.orderId,
      required this.itemList,
      required this.quantityList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var status = order['Status'];
    Color color = Colors.orange;
    if (status == "OPEN") {
      color = const Color.fromARGB(255, 255, 182, 64);
    } else if (status == "CLOSED") {
      color = Colors.green;
    } else if (status == "RETURNED") {
      color = Colors.red;
    } // Assuming the

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order ID # ${orderId.substring(orderId.length - 4)}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Order ID: $orderId',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.currency_rupee,
                          size: 16,
                          // weight: 50,
                        ),
                        Text(
                          order['amount'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 70, 70, 70),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '${order['Date']}, ${order['Time']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.only(
                            top: 2.0,
                            bottom: 2.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(6),
                            ),
                          ),
                          child: Text(
                            order['Status'] as String,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    const SizedBox(height: 10),
                    const Text(
                      'Products',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    //   ListView.builder(
                    //     //shrinkWrap: true,
                    //     // physics: const NeverScrollableScrollPhysics(),
                    //     itemCount: itemList.length,
                    //     itemBuilder: (context, index) {
                    //       return Column(
                    //         children: [
                    //           Row(
                    //             children: [
                    //               Text(
                    //                 itemList[index],
                    //                 style: const TextStyle(
                    //                   fontSize: 16,
                    //                 ),
                    //               ),
                    //               const Spacer(),
                    //               Text(
                    //                 itemList[index],
                    //                 style: const TextStyle(
                    //                   fontSize: 14,
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //           const Spacer(),
                    //           Text(
                    //             itemList[index],
                    //             style: const TextStyle(
                    //               fontSize: 14,
                    //             ),
                    //           ),
                    //         ],
                    //       );
                    //     },
                    //   ),
                    const Divider(
                      indent: 5,
                      endIndent: 5,
                    ),
                    pricing(
                      "Subtotal",
                      order['amount'].toString(),
                    ),
                    pricing(
                      "Shipment cost",
                      order['amount'].toString(),
                    ),
                    const Divider(
                      indent: 5,
                      endIndent: 5,
                    ),
                    pricing("Grand Total", order['amount'].toString(), flag: 0),
                  ],
                ),
              ),
            ),
            const Card(
              child: Text("sajal"),
            ),
          ],
        ),
      ),
    );
  }

  Row pricing(String titleText, String priceText, {int flag = 1}) {
    return Row(
      children: [
        Text(
          titleText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: flag == 0
                ? Color.fromARGB(255, 0, 0, 0)
                : Color.fromARGB(255, 92, 92, 92),
          ),
        ),
        const Spacer(),
        const Icon(
          Icons.currency_rupee,
          size: 16,
          // weight: 50,
        ),
        Text(
          priceText,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: flag == 0
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 92, 92, 92),
          ),
        ),
      ],
    );
  }
}
