import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  String id;
  String email;
  String fullName;
  String phoneNumber;
  String address;
  String city;
  String postalCode;
  bool isActive;
  Timestamp createdAt;

  CustomerModel({
    required this.id,
    required this.email,
    required this.fullName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.postalCode,
    required this.isActive,
    required this.createdAt,
  });

  factory CustomerModel.fromMap(String id, Map<String, dynamic> map) {
    return CustomerModel(
      id: id,
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      city: map['city'] ?? '',
      postalCode: map['postalCode'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: map['createdAt'].toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'city': city,
      'postalCode': postalCode,
      'isActive': isActive,
      'createdAt': createdAt,
    };
  }
}
