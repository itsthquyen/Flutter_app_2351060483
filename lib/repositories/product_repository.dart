import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductRepository {
  final CollectionReference _productRef =
  FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel product) async {
    try {
      await _productRef.doc(product.id).set({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'brand': product.brand,
        'stock': product.stock,
        'imageUrl': product.imageUrl,
        'rating': product.rating,
        'reviewCount': product.reviewCount,
        'isAvailable': product.isAvailable,
        'createdAt': product.createdAt,
      });
    } catch (e) {
      throw Exception("Lỗi thêm product: $e");
    }
  }


  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _productRef.doc(productId).get();

      if (!doc.exists) return null;

      return ProductModel.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception("Lỗi lấy product theo ID: $e");
    }
  }


  Future<List<ProductModel>> getAllProducts() async {
    try {
      final snapshot = await _productRef.get();

      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      throw Exception("Lỗi lấy danh sách products: $e");
    }
  }


  Future<List<ProductModel>> searchProducts(String keyword) async {
    try {
      final snapshot = await _productRef.get();

      final lowerKeyword = keyword.toLowerCase();

      return snapshot.docs
          .map((doc) =>
          ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .where((product) =>
      product.name.toLowerCase().contains(lowerKeyword) ||
          product.description.toLowerCase().contains(lowerKeyword) ||
          product.brand.toLowerCase().contains(lowerKeyword))
          .toList();
    } catch (e) {
      throw Exception("Lỗi tìm kiếm product: $e");
    }
  }


  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      final snapshot =
      await _productRef.where('category', isEqualTo: category).get();

      return snapshot.docs
          .map((doc) =>
          ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Lỗi lọc product theo category: $e");
    }
  }


  Future<void> updateProduct(ProductModel product) async {
    try {
      await _productRef.doc(product.id).update({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'brand': product.brand,
        'stock': product.stock,
        'imageUrl': product.imageUrl,
        'rating': product.rating,
        'reviewCount': product.reviewCount,
        'isAvailable': product.isAvailable,
      });
    } catch (e) {
      throw Exception("Lỗi cập nhật product: $e");
    }
  }

  Stream<List<ProductModel>> getProductsStream() {
    return _productRef.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) =>
          ProductModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }
}
