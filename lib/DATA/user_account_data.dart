import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:money_maker/API/auth_api.dart';
import 'package:money_maker/MODEL/user_account_model.dart';

class UserAccountData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String userID = AuthApi.auth.currentUser!.uid.toString();
  static const String docID = "user_accounts";
  static Future<void> createAccount() async {
    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection("accounts")
          .doc(docID)
          .set({
        "adsWatched": 0,
      });
    } catch (e) {
      log('Error creating account: $e');
    }
  }

  static Future<UserAccountModel?> getAccountData() async {
    try {
      QuerySnapshot accountSnapshot = await _firestore
          .collection('users')
          .doc(userID)
          .collection("accounts")
          .limit(1)
          .get();

      if (accountSnapshot.docs.isNotEmpty) {
        DocumentSnapshot accountDoc = accountSnapshot.docs.first;
        return UserAccountModel.fromFirestore(
            accountDoc.data() as Map<String, dynamic>);
      } else {
        log('Account not found for user: $userID');
        return null;
      }
    } catch (e) {
      log('Error fetching account data: $e');
      return null;
    }
  }

  static Future<void> updateTimerDuration(int timerDuration) async {
    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection("accounts")
          .doc(docID)
          .update({
        'timeDuration': timerDuration, // Store timer duration
      });
    } catch (e) {
      log('Error updating timer duration: $e');
    }
  }

  static Future<void> incrementCoins(int amount) async {
    try {
      await _firestore.collection('users').doc(userID).update({
        'coins': FieldValue.increment(amount),
      });
    } catch (e) {
      log('Error incrementing coins: $e');
    }
  }

  static Stream<int> getCoinCount() {
    try {
      return _firestore.collection('users').snapshots().map((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          // Get the first document in the snapshot
          DocumentSnapshot accountDoc = snapshot.docs.first;
          return accountDoc.get('coins') ?? 0; // Return coin count or 0
        } else {
          log('Account not found');
          return 0; // Return 0 if no account exists
        }
      });
    } catch (e) {
      log('Error fetching coin count: $e');
      return Stream.value(0); // Return a stream with 0 on error
    }
  }

  static Future<void> saveAdWatchCount(int adsWatched) async {
    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection("accounts")
          .doc(docID)
          .update({
        'adsWatched': adsWatched, // Update adsWatched to the provided value
      });
      log('Ad watch count updated to $adsWatched');
    } catch (e) {
      log('Error saving ad watch count: $e');
    }
  }

  static Future<DateTime?> getLastAdWatchTime() async {
    try {
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .doc(docID) // Replace with your account ID
          .get();

      if (snapshot.exists) {
        final data = snapshot.data();
        return (data!['lastAdWatchTime'] as Timestamp?)
            ?.toDate(); // Assuming you're storing a Timestamp in Firestore
      }
    } catch (e) {
      print("Error fetching last ad watch time: $e");
    }
    return null;
  }

  static Future<void> incrementAdsWatched() async {
    try {
      await _firestore
          .collection('users')
          .doc(userID)
          .collection("accounts")
          .doc(docID)
          .update({
        'adsWatched': FieldValue.increment(1),
        'lastAdWatchTime': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      log('Error incrementing ads watched: $e');
    }
  }

  static Future<int> getAdsWatchedCount() async {
    try {
      DocumentSnapshot accountDoc = await _firestore
          .collection('users')
          .doc(userID)
          .collection("accounts")
          .doc(docID)
          .get();

      if (accountDoc.exists) {
        return accountDoc.get('adsWatched') ??
            0; // Return ads watched count or 0
      } else {
        log('Account not found');
        return 0;
      }
    } catch (e) {
      log('Error fetching ads watched count: $e');
      return 0;
    }
  }

  static Future<void> resetAdsWatched() async {
    try {
      final userId = AuthApi.auth.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('accounts')
          .doc(docID) // Replace with your account ID
          .update({'adsWatched': 0});
    } catch (e) {
      log("Error resetting ads watched: $e");
    }
  }
}
