import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';

class OrderDetailsPage extends StatefulWidget {
  final Map<Object?, Object?> order;
  final String orderId;
  final String itemList;
  final String quantityList;

  const OrderDetailsPage({
    Key? key,
    required this.order,
    required this.orderId,
    required this.itemList,
    required this.quantityList,
  }) : super(key: key);

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  // void _launch
  String? selectedStatus;
  String newStatus = "none";
  Color color = Colors.orange;

  void update(String s) {
    setState(() {
      newStatus = s;
    });
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'OPEN':
        return Colors.orange;
      case 'CLOSED':
        return Colors.green;
      case 'RETURNED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Order ID # ${widget.orderId.substring(widget.orderId.length - 4)}',
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
                          'Order ID: ${widget.orderId}',
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
                          widget.order['amount'].toString(),
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
                          '${widget.order['Date']}, ${widget.order['Time']}',
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            await showModalBottomSheet<String>(
                              context: context,
                              builder: (BuildContext context) {
                                return Column(
                                  children: <Widget>[
                                    ListTile(
                                      title: const Text('OPEN'),
                                      onTap: () => {
                                        Navigator.pop(context),
                                        update('OPEN'),
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('CLOSED'),
                                      onTap: () => {
                                        Navigator.pop(context),
                                        update('CLOSED'),
                                      }, //Navigator.pop(context, 'CLOSED'),
                                    ),
                                    ListTile(
                                      title: const Text('RETURNED'),
                                      onTap: () => {
                                        Navigator.pop(context),
                                        update('RETURNED'),
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                            if (newStatus != "none") {
                              await FirebaseDatabase.instance
                                  .ref()
                                  .child('orders')
                                  .child(widget.orderId)
                                  .update({
                                'Status': newStatus,
                              });
                              // ignore: use_build_context_synchronously
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Order status updated'),
                                ),
                              );
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                              top: 2.0,
                              bottom: 2.0,
                              left: 10.0,
                              right: 10.0,
                            ),
                            decoration: BoxDecoration(
                              color: getStatusColor(
                                newStatus == "none"
                                    ? widget.order['Status'].toString()
                                    : newStatus,
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(6),
                              ),
                            ),
                            child: Text(
                              newStatus == "none"
                                  ? widget.order['Status'].toString()
                                  : newStatus,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
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
                    
                    const Divider(
                      indent: 5,
                      endIndent: 5,
                    ),
                    pricing(
                      "Subtotal",
                      widget.order['amount'].toString(),
                    ),
                    pricing(
                      "Shipment cost",
                      widget.order['amount'].toString(),
                    ),
                    const Divider(
                      indent: 5,
                      endIndent: 5,
                    ),
                    pricing("Grand Total", widget.order['amount'].toString(),
                        flag: 0),
                  ],
                ),
              ),
            ),
            Card(
              elevation: 5,
              color: const Color.fromARGB(255, 255, 255, 255),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Text(
                          "Customer Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    const Divider(),
                    Row(
                      children: [
                        const Text(
                          "Name : ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(176, 0, 0, 0),
                          ),
                        ),
                        const Text(
                          "Sajal Sahu",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        const Text(
                          "Mobile : ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(176, 0, 0, 0),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            launchUrl(Uri.parse("tel:+918349881787"));
                          },
                          child: const Text(
                            "+91 8349881787",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 0, 0, 0),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Row(
                      children: [
                        Text(
                          "Address : ",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(176, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    const Text("Status"),
                  ],
                ),
              ),
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
                ? const Color.fromARGB(255, 0, 0, 0)
                : const Color.fromARGB(255, 92, 92, 92),
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
