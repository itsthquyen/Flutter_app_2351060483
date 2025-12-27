import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'order_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo app - 2351060483"),
      ),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.shop),
            title: const Text("Sản phẩm"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProductListScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text("Đơn hàng của tôi"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OrderListScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
