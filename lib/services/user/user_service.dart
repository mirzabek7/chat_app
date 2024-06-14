import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:test_chat_app/models/user.dart';

class UserService with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Users> getCurrentUser() async {
    final currentUser =
        await firestore.collection('users').doc(auth.currentUser!.uid).get();

    final user = Users(
      uid: currentUser.data()!['uid'],
      email: currentUser.data()!['email'],
      fullName: currentUser.data()!['name'],
    );
    return user;
  }

  // get All users
  Future<List<Users>> getAllUsers() async {
    List<Users> allUsers = [];
    final users = await firestore.collection('users').get();
    for (var i = 0; i < users.docs.length; i++) {
      allUsers.add(
        Users(
          uid: users.docs[i]['uid'],
          email: users.docs[i]['email'],
          fullName: users.docs[i]['name'],
        ),
      );
    }
    return allUsers;
  }

  Future<List<Users>> searchedUsers(String query) async {
    List<Users> results = [];
    List<Users> users = await getAllUsers();

    results = users
        .where(
            (user) => user.fullName.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return results;
  }

  Future<void> updateUserStatus(bool status) async {
    _firestore.collection('users').doc(auth.currentUser!.uid).update({
      'isOnline': status,
    });
  }

  String getCurrentUserUid() {
    return auth.currentUser!.uid;
  }

  Stream<DocumentSnapshot> userStatus(String uid) {
    return _firestore.collection('users').doc(uid).snapshots();
  }
}
