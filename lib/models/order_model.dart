import 'package:cloud_firestore/cloud_firestore.dart';

/// =======================
/// ORDER ITEM
/// =======================
class OrderItemModel {
  final String productId;
  final String productName;
  final int quantity;
  final double price;

  OrderItemModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
  });

  double get total => price * quantity;

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['productId'],
      productName: map['productName'],
      quantity: map['quantity'],
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
    };
  }
}

/// =======================
/// ORDER MODEL
/// =======================
class OrderModel {
  final String orderId;
  final String customerId;

  final List<OrderItemModel> items;

  final double subtotal;
  final double shippingFee;
  final double total;

  final DateTime orderDate;

  final String shippingAddress;
  final String status; // pending, confirmed, processing, shipped, delivered, cancelled

  final String paymentMethod; // cash, card, bank_transfer
  final String paymentStatus; // pending, paid, failed

  final String? notes; // nullable

  OrderModel({
    required this.orderId,
    required this.customerId,
    required this.items,
    required this.subtotal,
    required this.shippingFee,
    required this.total,
    required this.orderDate,
    required this.shippingAddress,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    this.notes,
  });

  /// =======================
  /// FROM FIRESTORE
  /// =======================
  factory OrderModel.fromFirestore(
      String id,
      Map<String, dynamic> map,
      ) {
    return OrderModel(
      orderId: id,
      customerId: map['customerId'],
      items: (map['items'] as List)
          .map((e) => OrderItemModel.fromMap(e))
          .toList(),
      subtotal: (map['subtotal'] as num).toDouble(),
      shippingFee: (map['shippingFee'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
      orderDate: (map['orderDate'] as Timestamp).toDate(),
      shippingAddress: map['shippingAddress'],
      status: map['status'],
      paymentMethod: map['paymentMethod'],
      paymentStatus: map['paymentStatus'],
      notes: map['notes'],
    );
  }

  get address => null;


  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'shippingFee': shippingFee,
      'total': total,
      'orderDate': Timestamp.fromDate(orderDate),
      'shippingAddress': shippingAddress,
      'status': status,
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
      'notes': notes,
    };
  }
}
