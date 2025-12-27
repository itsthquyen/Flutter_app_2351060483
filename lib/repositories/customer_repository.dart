import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/customer_model.dart';

class CustomerRepository {
  final CollectionReference _customerRef =
  FirebaseFirestore.instance.collection('customers');

  final CollectionReference _orderRef =
  FirebaseFirestore.instance.collection('orders');

  Future<void> addCustomer(CustomerModel customer) async {
    try {
      await _customerRef.doc(customer.id).set(customer.toMap());
    } catch (e) {
      throw Exception("Lỗi khi thêm customer: $e");
    }
  }

  Future<CustomerModel?> getCustomerById(String customerId) async {
    try {
      final doc = await _customerRef.doc(customerId).get();

      if (!doc.exists) {
        return null;
      }

      return CustomerModel.fromMap(
        doc.id,
        doc.data() as Map<String, dynamic>,
      );
    } catch (e) {
      throw Exception("Lỗi lấy customer theo ID: $e");
    }
  }

  Future<List<CustomerModel>> getAllCustomers() async {
    try {
      final snapshot = await _customerRef.get();

      return snapshot.docs.map((doc) {
        return CustomerModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    } catch (e) {
      throw Exception("Lỗi lấy danh sách customers: $e");
    }
  }

  Future<void> updateCustomer(CustomerModel customer) async {
    try {
      await _customerRef.doc(customer.id).update({
        'email': customer.email,
        'fullName': customer.fullName,
        'phoneNumber': customer.phoneNumber,
        'address': customer.address,
        'city': customer.city,
        'postalCode': customer.postalCode,
        'isActive': customer.isActive,
      });
    } catch (e) {
      throw Exception("Lỗi cập nhật customer: $e");
    }
  }

  
  Future<void> deleteCustomer(String customerId) async {
    try {
      final orderSnapshot = await _orderRef
          .where('customerId', isEqualTo: customerId)
          .where(
        'status',
        whereIn: ['pending', 'confirmed', 'processing'],
      )
          .get();

      if (orderSnapshot.docs.isNotEmpty) {
        throw Exception(
            "Không thể xóa customer vì còn đơn hàng đang xử lý");
      }

      await _customerRef.doc(customerId).delete();
    } catch (e) {
      throw Exception("Lỗi xóa customer: $e");
    }
  }

  Future<dynamic> getCustomerByEmail(String trim) async {}
}
