import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chi tiết sản phẩm")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('products')
            .doc(productId)
            .get(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final p = snap.data!;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(p['imageUrl'], height: 200),
                const SizedBox(height: 10),
                Text(p['name'], style: const TextStyle(fontSize: 20)),
                Text("Giá: ${p['price']}"),
                Text("Còn lại: ${p['stock']}"),
                const SizedBox(height: 20),
                if (p['stock'] > 0)
                  ElevatedButton(
                    onPressed: () {
                      // add to cart (local state)
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Đã thêm vào giỏ")),
                      );
                    },
                    child: const Text("Thêm vào giỏ hàng"),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
