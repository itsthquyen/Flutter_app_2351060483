import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String id;
  String name;
  String description;
  double price;
  String category;
  String brand;
  int stock;
  String imageUrl;
  double rating;
  int reviewCount;
  bool isAvailable;
  Timestamp createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.brand,
    required this.stock,
    required this.imageUrl,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.createdAt,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      name: map['name'],
      description: map['description'],
      price: map['price'].toDouble(),
      category: map['category'],
      brand: map['brand'],
      stock: map['stock'],
      imageUrl: map['imageUrl'],
      rating: map['rating'].toDouble(),
      reviewCount: map['reviewCount'],
      isAvailable: map['isAvailable'],
      createdAt: map['createdAt'].toDate(),
    );
  }
}
