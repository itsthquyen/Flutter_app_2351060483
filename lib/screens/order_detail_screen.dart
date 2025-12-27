import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailScreen extends StatelessWidget {
  final String orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết đơn hàng")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('orders')
            .doc(orderId)
            .get(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final order = snap.data!;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text("Trạng thái: ${order['status']}"),
              Text("Tổng tiền: ${order['total']}"),
              const Divider(),
              ...order['items'].map<Widget>((item) {
                return ListTile(
                  title: Text(item['productName']),
                  trailing: Text("x${item['quantity']}"),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
