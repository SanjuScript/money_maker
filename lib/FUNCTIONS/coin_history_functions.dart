import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_maker/API/auth_api.dart';
import 'package:money_maker/MODEL/coin_transaction_model.dart';

class CoinHistoryManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _userID = AuthApi.auth.currentUser!.uid.toString();

  static Future<void> addCoinTransaction({
    required String name,
    required int coins,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(_userID)
          .collection('coin_transactions')
          .add({
        'name': name,
        'coins': coins,
        'time': FieldValue.serverTimestamp(),
        'userID': _userID
      });
      log("Coin transaction history added successfully.");
    } catch (e) {
      log("Error adding coin transaction: $e");
    }
  }

  static Future<void> addCoinTransactionRefere({
    required String name,
    required int coins,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('coin_transactions')
          .add({
        'name': name,
        'coins': coins,
        'time': FieldValue.serverTimestamp(),
        'userID': userId
      });

      log("Coin transaction history added successfully.");
    } catch (e) {
      log("Error adding coin transaction: $e");
    }
  }

  static Future<void> incrementRefererCoins(String userId, int coins) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'coins': FieldValue.increment(coins),
      });
      await addCoinTransactionRefere(
          name: "Referral Bonus", coins: coins, userId: userId);
      log("User's coin count incremented by $coins.");
    
    } catch (e) {
      log("Error incrementing user's coin count: $e");
    }
  }

  static Future<List<CoinTransactionModel>> getCoinHistory() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .doc(_userID)
          .collection('coin_transactions')
          .orderBy('time', descending: true)
          .get();

      List<CoinTransactionModel> transactions = querySnapshot.docs
          .map((doc) => CoinTransactionModel.fromMap(doc.data(), _userID))
          .toList();

      return transactions;
    } catch (e) {
      log("Error fetching coin history: $e");
      return [];
    }
  }
}
