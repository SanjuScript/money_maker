import 'dart:developer';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';
import 'package:money_maker/API/auth_api.dart';
import 'package:money_maker/MODEL/user_model.dart';

class UserData {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String userID = AuthApi.auth.currentUser!.uid.toString();
  static Future<void> updateTimerDuration(int timerDuration) async {
    try {
      await _firestore.collection('users').doc(userID).update({
        'timerDuration': timerDuration, // Store timer duration
      });
    } catch (e) {
      log('Error updating timer duration: $e');
    }
  }

  static Future<UserDataModel?> getUserData() async {
    try {
      
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userID).get();

      if (userDoc.exists) {
        return UserDataModel.fromFirestore(
            userDoc.data() as Map<String, dynamic>);
      } else {
        log('User not found');
        return null;
      }
    } catch (e) {
      log('Error fetching user data: $e');
      return null;
    }
  }

  static Future<String?> getUserReferralCode() async {
    try {
      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userID)
          .get(const GetOptions(source: Source.serverAndCache));

      if (userDoc.exists && userDoc.data() != null) {
        return (userDoc.data() as Map<String, dynamic>)['referalID'] as String?;
      } else {
        log('User document does not exist or field missing.');
        return null;
      }
    } catch (e) {
      log('Error fetching referral code: $e');
      return null;
    }
  }
}
