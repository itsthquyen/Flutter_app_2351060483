import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app_2351060483/providers/cart_provider.dart';
import '../models/order_model.dart';

class OrderRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference get _orderRef => _db.collection('orders');
  CollectionReference get _productRef => _db.collection('products');


  Future<void> createOrder({
    required String customerId,
    required List<OrderItemModel> items,
    required String shippingAddress,
    required String paymentMethod,
    String? notes, required List<CartItem> cartItems,
  }) async {
    await _db.runTransaction((transaction) async {
      double subtotal = 0;

      // 1. Kiểm tra stock từng sản phẩm
      for (var item in items) {
        final productDoc =
        await transaction.get(_productRef.doc(item.productId));

        if (!productDoc.exists) {
          throw Exception("Sản phẩm không tồn tại");
        }

        final int stock = productDoc['stock'];
        if (stock < item.quantity) {
          throw Exception("Sản phẩm ${item.productName} đã hết hàng");
        }

        subtotal += item.total;
      }

      // 2. Tính phí
      double shippingFee = 30000;
      double total = subtotal + shippingFee;

      // 3. Tạo order
      final orderDoc = _orderRef.doc();

      transaction.set(orderDoc, {
        'customerId': customerId,
        'items': items.map((e) => e.toMap()).toList(),
        'subtotal': subtotal,
        'shippingFee': shippingFee,
        'total': total,
        'orderDate': Timestamp.now(),
        'shippingAddress': shippingAddress,
        'status': 'pending',
        'paymentMethod': paymentMethod,
        'paymentStatus': 'pending',
        'notes': notes,
      });

      // 4. Trừ stock
      for (var item in items) {
        transaction.update(
          _productRef.doc(item.productId),
          {'stock': FieldValue.increment(-item.quantity)},
        );
      }
    });
  }


  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db.runTransaction((transaction) async {
      final orderDoc = await transaction.get(_orderRef.doc(orderId));

      if (!orderDoc.exists) {
        throw Exception("Đơn hàng không tồn tại");
      }

      final data = orderDoc.data() as Map<String, dynamic>;
      final oldStatus = data['status'];

      // Nếu hủy đơn → hoàn stock
      if (status == 'cancelled' && oldStatus != 'cancelled') {
        final items = (data['items'] as List)
            .map((e) => OrderItemModel.fromMap(e))
            .toList();

        for (var item in items) {
          transaction.update(
            _productRef.doc(item.productId),
            {'stock': FieldValue.increment(item.quantity)},
          );
        }
      }

      transaction.update(orderDoc.reference, {'status': status});
    });
  }


  Future<List<OrderModel>> getOrdersByCustomer(String customerId) async {
    final snapshot = await _orderRef
        .where('customerId', isEqualTo: customerId)
        .orderBy('orderDate', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => OrderModel.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    ))
        .toList();
  }

  // =====================================================
  // 4. LẤY ĐƠN HÀNG THEO STATUS (2 điểm)
  // =====================================================
  Future<List<OrderModel>> getOrdersByStatus(String status) async {
    final snapshot =
    await _orderRef.where('status', isEqualTo: status).get();

    return snapshot.docs
        .map((doc) => OrderModel.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    ))
        .toList();
  }

  // =====================================================
  // 5. LẤY ĐƠN HÀNG THEO ID (1 điểm)
  // =====================================================
  Future<OrderModel?> getOrderById(String orderId) async {
    final doc = await _orderRef.doc(orderId).get();

    if (!doc.exists) return null;

    return OrderModel.fromFirestore(
      doc.id,
      doc.data() as Map<String, dynamic>,
    );
  }

  Future<void> cancelOrder(String orderId) async {}
}
