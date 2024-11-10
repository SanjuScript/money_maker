import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_cloud_firestore/firebase_cloud_firestore.dart';

class AuthApi {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static CollectionReference users =
      FirebaseFirestore.instance.collection('users');
  static DocumentReference documentRef = FirebaseFirestore.instance
      .collection('users')
      .doc(auth.currentUser!.uid);
}
