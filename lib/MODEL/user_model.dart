import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class UserDataModel {
  final String email;
  final String displayName;
  final String photoURL;
  final DateTime? createdAt;
  final int coins;
  final String? deviceId;

  UserDataModel({
    required this.email,
    required this.displayName,
    required this.photoURL,
    required this.coins,
    this.createdAt,
    this.deviceId,
  });

  factory UserDataModel.fromFirestore(Map<String, dynamic> data) {
    return UserDataModel(
      coins: data['coins'] ?? '',
      email: data['email'] ?? '',
      deviceId: data['deviceId'] ?? '',
      displayName: data['displayName'] ?? '',
      photoURL: data['photoURL'] ?? '',
      createdAt: (data['createdAt'] != null)
          ? (data['createdAt'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'coins': coins,
      'deviceId': deviceId,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
