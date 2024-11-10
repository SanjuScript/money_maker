import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_maker/DATA/user_account_data.dart';
import 'package:money_maker/FUNCTIONS/coin_history_functions.dart';
import 'package:money_maker/HELPER/device_info_helper.dart';
import 'package:money_maker/HELPER/referal_code_genrator.dart';
import 'package:money_maker/SCREENS/AUTH/login_screen.dart';
import 'package:money_maker/SCREENS/home_screen.dart';
import 'package:money_maker/SECURITY/storage_manager.dart';

class LoginAuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  User? _user;
  User get user => _user!;

  bool isLoading = false;

  Future<void> refreshUserData() async {
    _user = _auth.currentUser;
    notifyListeners();
  }

  Future<dynamic> googleSignIn(BuildContext context,
      {String? referelCode}) async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If the user cancels the sign-in, return null
      if (googleUser == null) {
        log('Sign-in aborted by the user');
        return null; // or handle as per your app's logic
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the credential
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      notifyListeners();

      // Check if the user is not null
      if (user != null) {
        // Check if the user already exists in Firestore
        DocumentSnapshot userDoc = await users.doc(user.uid).get();
        await UserStateManager.saveState('isAuthenticated', true);
        // If user does not exist, create a new user document
        if (!userDoc.exists) {
          String userRefID = generateReferralCode();
          String? referrerId;
          if (referelCode != null) {
            referrerId = await validateReferralCode(referelCode.toString());
            log("Referrer ID found: $referrerId");
          }
          await users.doc(user.uid).set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt': FieldValue.serverTimestamp(),
            'coins': 10,
            'referalID': userRefID,
            'referredBy': referrerId, // Set the actual referrer ID here
          }); // Award bonus if referrer ID is valid
          await CoinHistoryManager.addCoinTransaction(
            name: "Sign up Bonus",
            coins: 10,
          );
          if (referrerId != null) {
            await CoinHistoryManager.incrementRefererCoins(referrerId, 25);
            await CoinHistoryManager.addCoinTransaction(
              name: "Referral Bonus",
              coins: 25,
            );
            await users
                .doc(user.uid)
                .update({"coins": FieldValue.increment(30)});

            log("Referral bonus awarded to referrer with ID $referrerId");
          } else {
            log("Invalid referral code provided");
          }

          log("User document created for ${user.email}");
        } else {
          log("User document already exists for ${user.email}");
        }
        String deviceID = await DeviceInfoHelper.getDeviceId();
        await DeviceInfoHelper.storeDeviceId(deviceID);
        await UserAccountData.createAccount();
        // ignore: use_build_context_synchronously
        // await navigateTO(context, true);
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomeScreen(key: ValueKey(user.uid),)),
        );
      }

      return user; // Return the user for further processing if needed
    } on Exception catch (e) {
      log('Error signing in with Google: $e');
      // Handle the error (show a message to the user, etc.)
      return null; // Return null or rethrow the error as needed
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    await UserStateManager.saveState('isAuthenticated', false);
    _user = null;
    await refreshUserData();
    notifyListeners();
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<String?> validateReferralCode(String referralCode) async {
    var referrerSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('referalID', isEqualTo: referralCode)
        .get();

    if (referrerSnapshot.docs.isNotEmpty) {
      String referrerId = referrerSnapshot.docs.first.id;
      log("Referral code $referralCode is valid, referrer ID: $referrerId");
      return referrerId;
    } else {
      log("Referral code $referralCode is invalid");
      return null;
    }
  }
}
