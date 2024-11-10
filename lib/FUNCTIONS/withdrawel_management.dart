import 'dart:developer';

import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:money_maker/API/auth_api.dart';
import 'package:money_maker/FUNCTIONS/coin_data.dart';
import 'package:money_maker/FUNCTIONS/coin_history_functions.dart';
import 'package:money_maker/SCREENS/coin_credit_history.dart';

class WithdrawelManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final String _userID = AuthApi.auth.currentUser!.uid.toString();

  static Future<void> widthrawAmount(
      {required int amount, required int coins, required int newCoins,required String upiID}) async {
    try {
      bool allowed = await isWithdrawalAllowed();
       if (!allowed) {
         Fluttertoast.showToast(
          msg: "Withdrawal attempt blocked. Less than 7 days since last withdrawal.",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
      await _firestore
          .collection('users')
          .doc(_userID)
          .collection('withdrawel_requests')
          .add({
        'coins': coins,
        'amount': amount,
        'time': FieldValue.serverTimestamp(),
        'status': false,
        "upiID":upiID,
        'userID': _userID
      });
      await CoinHistoryManager.addCoinTransaction(
          coins: coins, name: "Withdrawel");
      await CoinData.updateCoinCount(newCoins);
      log("Coin transaction history added successfully.");
    } catch (e) {
      log("Error adding coin transaction: $e");
    }
  }

  static Future<DateTime?> getLastWithdrawalDate() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .doc(_userID)
          .collection('withdrawel_requests')
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        Timestamp lastWithdrawalTimestamp = querySnapshot.docs.first['time'];
        return lastWithdrawalTimestamp.toDate();
      } else {
        log("No withdrawal records found.");
        return null;
      }
    } catch (e) {
      log("Error getting last withdrawal date: $e");
      return null;
    }
  }

  static Future<bool> isWithdrawalAllowed() async {
    DateTime? lastWithdrawalDate = await getLastWithdrawalDate();

    if (lastWithdrawalDate == null) {
      return true;
    } else {
      DateTime currentDate = DateTime.now();
      Duration difference = currentDate.difference(lastWithdrawalDate);

      if (difference.inDays >= 7) {
        return true;
      } else {
        Fluttertoast.showToast(
            msg:
                "Withdrawal not allowed. Try again in ${7 - difference.inDays} days.");
        return false;
      }
    }
  }
  static Future<bool?> getLastWithdrawalStatus() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('users')
          .doc(_userID)
          .collection('withdrawel_requests')
          .orderBy('time', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        bool status = querySnapshot.docs.first['status'];
        return status; // Return the status of the last withdrawal
      } else {
        log("No withdrawal records found.");
        return null; // No withdrawals found
      }
    } catch (e) {
      log("Error getting last withdrawal status: $e");
      return null;
    }
  }
}
