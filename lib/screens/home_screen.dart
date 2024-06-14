import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_chat_app/models/chat.dart';
import 'package:test_chat_app/services/auth/auth_service.dart';
import 'package:test_chat_app/services/chat/chat_service.dart';
import 'package:test_chat_app/services/user/user_service.dart';
import 'package:test_chat_app/widgets/search_field.dart';

import '../widgets/chat_user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    final user = Provider.of<UserService>(context, listen: false);

    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await user.updateUserStatus(true);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    final user = Provider.of<UserService>(context, listen: false);
    if (state == AppLifecycleState.resumed) {
      await user.updateUserStatus(true);
    } else {
      await user.updateUserStatus(false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  void signOut() {
    final auth = Provider.of<AuthService>(context, listen: false);
    auth.logout();
  }

  final chat = ChatService();
  List<Color> _colors = [
    Colors.green,
    Colors.yellow,
    Colors.blue,
    Colors.pink,
  ];

  int getRandomNumber() {
    Random random = Random();
    return random
        .nextInt(4); // nextInt(4) генерирует числа от 0 до 3 включительно
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Чаты',
            style: TextStyle(
              fontSize: 32,
              fontFamily: 'Gilroy',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 6.0, bottom: 24.0, left: 10, right: 10),
              child: SearchField(),
            ),
            const Divider(
              height: 1,
              color: Color(0xffEDF2F6),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: StreamBuilder(
                  stream: chat.getChats(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data != null) {
                      final chats = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: chats.length,
                        shrinkWrap: true,
                        itemBuilder: (ctx, index) {
                          int numb = getRandomNumber();
                          final time =
                              chats[index]['lastMessageTime'] as Timestamp;
                          Chats otherUser = Chats(
                            chatUid: chats[index].id,
                            userAName: chats[index]['userAName'],
                            userAUid: chats[index]['userAUid'],
                            userBName: chats[index]['userBName'],
                            userBUid: chats[index]['userBUid'],
                            lastMessage: chats[index]['lastMessage'],
                            lastMessageSenderUid: chats[index]
                                ['lastMessageSenderUid'],
                            lastMessageTime: time.toDate(),
                          );
                          if (otherUser.lastMessage.isNotEmpty) {
                            return ChatUser(
                              chat: otherUser,
                              randomColor: _colors[numb],
                            );
                          }
                          return null;
                        },
                      );
                    }
                    if (snapshot.data == null) {
                      return const Center(
                        child: Text(
                          'Пока ничего нет \n Через поиск можете найти людей',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
