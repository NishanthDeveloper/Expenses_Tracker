import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coin_compass/firebase_services/resources/storage_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:coin_compass/firebase_services/model/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required int monthlyIncome,
    required Uint8List file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          file != null) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage("profilePics", file, false);
        model.User user = model.User(
          username: username,
          email: email,
          uid: cred.user!.uid,
          photoUrl: photoUrl,
          monthlyIncome: monthlyIncome,
        );
        await _firestore
            .collection("users")
            .doc(cred.user!.uid)
            .set(user.toJson());
        return "Success";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return "success";
      } else {
        return "Please enter both email and password";
      }
    } catch (error) {
      // Handle specific Firebase Authentication exceptions
      if (error is FirebaseAuthException) {
        switch (error.code) {
          case 'user-not-found':
            return "No user found with this email.";
          case 'wrong-password':
            return "Invalid password.";
          case 'invalid-email':
            return "Invalid email address.";
          // Add more cases as needed for other exceptions
          default:
            return "An error occurred during authentication.";
        }
      } else {
        // Handle other non-Firebase exceptions
        return "An unexpected error occurred: $error";
      }
    }
  }
}
