import 'package:cloud_firestore/cloud_firestore.dart';

class CoinTransactionModel {
  final String name;
  final int coins;
  final DateTime? time;
  final String userId;

  CoinTransactionModel({
    required this.name,
    required this.coins,
    required this.userId,
    this.time,
  });

  factory CoinTransactionModel.fromMap(
      Map<String, dynamic> data, String userId) {
    return CoinTransactionModel(
      name: data['name'] ?? '',
      coins: data['coins'] ?? 0,
      userId: userId,
      time: (data['time'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'coins': coins,
      'time': FieldValue.serverTimestamp(),
      'userId': userId,
    };
  }
}
