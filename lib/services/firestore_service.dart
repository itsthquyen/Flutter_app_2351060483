import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference customers() => _db.collection('customers');
  CollectionReference products() => _db.collection('products');
  CollectionReference orders() => _db.collection('orders');
}
