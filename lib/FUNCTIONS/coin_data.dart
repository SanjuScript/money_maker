import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

import 'package:money_maker/API/auth_api.dart';

class CoinData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _userID = AuthApi.auth.currentUser!.uid.toString();
  static Future<int> getCoinCount() async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await _firestore.collection('users').doc(_userID).get();

      if (userDoc.exists && userDoc.data() != null) {
        return userDoc.data()!['coins'] ?? 0;
      } else {
        log("User document not found or 'coins' field is missing.");
        return 0;
      }
    } catch (e) {
      log("Error fetching coin count: $e");
      return 0;
    }
  }
   static Future<void> updateCoinCount(int newCoinCount) async {
    try {
      await _firestore.collection('users').doc(_userID).update({
        'coins': newCoinCount,
      });
      log("Coin count updated successfully.");
    } catch (e) {
      log("Error updating coin count: $e");
    }
  }
}
