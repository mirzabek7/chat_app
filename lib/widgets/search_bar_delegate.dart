import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:test_chat_app/chat_icons.dart';
import 'package:test_chat_app/screens/chat_screen.dart';
import 'package:test_chat_app/services/chat/chat_service.dart';
import 'package:test_chat_app/services/user/user_service.dart';

class SearchBarDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      TextButton(
        onPressed: () {
          query = '';
        },
        child: const Text(
          'CLEAR',
          style: TextStyle(
            color: Colors.blue,
            fontSize: 14,
          ),
        ),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(
        Chat.btn,
        color: Color(0xff2B333E),
        size: 36,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final users = Provider.of<UserService>(context);
    return FutureBuilder(
      future: users.searchedUsers(query),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data != null &&
            query.isNotEmpty &&
            snapshot.data!.isNotEmpty) {
          final data = snapshot.data;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemBuilder: (c, index) {
              if (data[index].uid != users.getCurrentUserUid()) {
                return ListTile(
                  onTap: () async {
                    final chatService =
                        Provider.of<ChatService>(context, listen: false);
                    final chat = await chatService.createNewChat(data[index]);
                    List<String> names = chat.userBName.split(' ');
                    String nickname =
                        names[0].substring(0, 1) + names[1].substring(0, 1);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ChatScreen(
                          chat,
                          nickname,
                          chat.userBName,
                          Colors.green,
                        ),
                      ),
                    );
                  },
                  title: Text(
                    data[index].fullName,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                );
              } else {
                return null;
              }
            },
            itemCount: data!.length,
          );
        }
        if (snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Ничег не найдено',
              style: TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
