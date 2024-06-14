import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:test_chat_app/models/chat.dart';
import 'package:test_chat_app/services/user/user_service.dart';
import '../../models/user.dart';

class ChatService with ChangeNotifier {
  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  // create chat document
  Future<Chats> createNewChat(Users userB) async {
    final userA = await UserService().getCurrentUser();
    String uid = UniqueKey().toString();
    final check = await checkChatDocument(userB.uid);

    if (check == null) {
      await firestore.collection('chats').doc(uid).set({
        'userAName': userA.fullName,
        'userAUid': userA.uid,
        'userBName': userB.fullName,
        'userBUid': userB.uid,
        'lastMessageSenderUid': '',
        'lastMessage': '',
        'lastMessageTime': Timestamp.now(),
      });

      return Chats(
          chatUid: uid,
          userAName: userA.fullName,
          userAUid: userA.uid,
          userBName: userB.fullName,
          userBUid: userB.uid,
          lastMessage: '',
          lastMessageSenderUid: '',
          lastMessageTime: DateTime.now());
    } else {
      return check;
    }
  }

  Stream<QuerySnapshot> getChats() {
    return firestore
        .collection('chats')
        .where(
          Filter.or(
            Filter('userAUid', isEqualTo: auth.currentUser!.uid),
            Filter('userBUid', isEqualTo: auth.currentUser!.uid),
          ),
        )
        .snapshots();
  }

  Future<void> sendMessage(String chatUid, String? text, File? image) async {
    late String downloadUrl;
    if (image != null) {
      var imageName = DateTime.now().millisecondsSinceEpoch.toString();
      try {
        var storageRef = FirebaseStorage.instance
            .ref()
            .child('driver_images/$imageName.jpg');
        var uploadTask = storageRef.putFile(image);
        downloadUrl = await (await uploadTask).ref.getDownloadURL();
      } catch (e) {
        print(e);
      }
    }

    firestore
        .collection('chats')
        .doc(chatUid)
        .collection('messages')
        .doc(UniqueKey().toString())
        .set({
      'text': text,
      'imageUrl': image != null ? downloadUrl : '',
      'isImage': image != null ? true : false,
      'senderUid': auth.currentUser!.uid,
      'sentTime': Timestamp.now(),
    });
    if (image != null) {
      firestore.collection('chats').doc(chatUid).update({
        'lastMessageTime': Timestamp.now(),
        'lastMessageSenderUid': auth.currentUser!.uid
      });
    } else {
      firestore.collection('chats').doc(chatUid).update({
        'lastMessage': text,
        'lastMessageTime': Timestamp.now(),
        'lastMessageSenderUid': auth.currentUser!.uid
      });
    }
  }

  Stream<QuerySnapshot> getMessages(String chatUid) {
    return firestore
        .collection('chats')
        .doc(chatUid)
        .collection('messages')
        .orderBy('sentTime', descending: true)
        .snapshots();
  }

  Future<Chats?> checkChatDocument(String userUid) async {
    var count = await firestore
        .collection('chats')
        .where(
          Filter.or(
            Filter.and(
              Filter('userAUid', isEqualTo: auth.currentUser!.uid),
              Filter('userBUid', isEqualTo: userUid),
            ),
            Filter.and(
              Filter('userBUid', isEqualTo: auth.currentUser!.uid),
              Filter('userAUid', isEqualTo: userUid),
            ),
          ),
        )
        .get();
    if (count.docs.isNotEmpty) {
      final chat = count.docs[0];
      final time = chat['lastMessageTime'] as Timestamp;
      return Chats(
        chatUid: chat.id,
        userAName: chat['userAName'],
        userAUid: chat['userAUid'],
        userBName: chat['userBName'],
        userBUid: chat['userBUid'],
        lastMessage: chat['lastMessage'],
        lastMessageSenderUid: chat['lastMessageSenderUid'],
        lastMessageTime: time.toDate(),
      );
    } else {
      return null;
    }
  }
}
