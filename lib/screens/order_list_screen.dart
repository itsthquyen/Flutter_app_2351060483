import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'order_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  Future<String?> _getCustomerId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('customerId');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đơn hàng của tôi")),
      body: FutureBuilder<String?>(
        future: _getCustomerId(),
        builder: (context, snap) {
          if (!snap.hasData) return const SizedBox();

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('orders')
                .where('customerId', isEqualTo: snap.data)
                .orderBy('orderDate', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((doc) {
                  return ListTile(
                    title: Text("Order #${doc.id}"),
                    subtitle: Text(doc['status']),
                    trailing: Text("${doc['total']} đ"),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            OrderDetailScreen(orderId: doc.id),
                      ),
                    ),
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
