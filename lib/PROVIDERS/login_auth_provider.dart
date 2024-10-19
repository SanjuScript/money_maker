import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<dynamic> googleSignIn(BuildContext context) async {
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

      // Check if the user is not null
      if (user != null) {
        // Check if the user already exists in Firestore
        DocumentSnapshot userDoc = await users.doc(user.uid).get();
        await UserStateManager.saveState('isAuthenticated', true);
        // If user does not exist, create a new user document
        if (!userDoc.exists) {
          await users.doc(user.uid).set({
            'email': user.email,
            'displayName': user.displayName,
            'photoURL': user.photoURL,
            'createdAt':
                FieldValue.serverTimestamp(), // Store the time of creation
          });
          log("User document created for ${user.email}");
        } else {
          log("User document already exists for ${user.email}");
        }
      // ignore: use_build_context_synchronously
      await  navigateTO(context, true);
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
    // ignore: use_build_context_synchronously
    await navigateTO(context, false);
    _user = null;
    notifyListeners();
  }
}
