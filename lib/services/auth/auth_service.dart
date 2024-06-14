import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService with ChangeNotifier {
  final firebaseInstance = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

// sign in
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final user = await firebaseInstance.signInWithEmailAndPassword(
          email: email, password: password);
      _firestore.collection('users').doc(user.user!.uid).update({
        'isOnline': true,
      });

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// create user
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final user = await firebaseInstance.createUserWithEmailAndPassword(
          email: email, password: password);
      _firestore.collection('users').doc(user.user!.uid).set({
        'uid': user.user!.uid,
        'email': user.user!.email,
        'name': name,
        'isOnline': true,
      });
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// logout
  Future<void> logout() async {
    await firebaseInstance.signOut();
  }
}
