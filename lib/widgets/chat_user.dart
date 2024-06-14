import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_chat_app/models/chat.dart';
import 'package:test_chat_app/screens/chat_screen.dart';
import 'package:test_chat_app/services/user/user_service.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class ChatUser extends StatefulWidget {
  ChatUser({
    super.key,
    required this.chat,
    required this.randomColor,
  });
  Chats chat;
  final Color randomColor;

  @override
  State<ChatUser> createState() => _ChatUserState();
}

class _ChatUserState extends State<ChatUser> {
  String currentUserUID = UserService().getCurrentUserUid();
  Future<void> openChat() async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => ChatScreen(
        widget.chat,
        getNickName(),
        currentUserUID == widget.chat.userAUid
            ? widget.chat.userBName
            : widget.chat.userAName,
        widget.randomColor,
      ),
    ));
  }

  String getNickName() {
    List<String> names = currentUserUID == widget.chat.userAUid
        ? widget.chat.userBName.split(' ')
        : widget.chat.userAName.split(' ');
    String nickname = names[0].substring(0, 1) + names[1].substring(0, 1);
    return nickname;
  }

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('ru', timeago.RuMessages());
  }

  @override
  Widget build(BuildContext context) {
    String nickname = getNickName();
    final difference =
        DateTime.now().difference(widget.chat.lastMessageTime).inDays;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
      onTap: () {
        openChat();
      },
      shape: const Border(
        bottom: BorderSide(
          color: Color(0xffEDF2F6),
        ),
      ),
      style: ListTileStyle.drawer,
      leading: CircleAvatar(
        backgroundColor: widget.randomColor,
        radius: 34,
        child: Text(
          nickname,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      title: Text(
        currentUserUID == widget.chat.userAUid
            ? widget.chat.userBName
            : widget.chat.userAName,
        style: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600, fontFamily: 'Gilray'),
      ),
      subtitle: Text(
        widget.chat.lastMessage,
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            fontFamily: 'Gilray',
            color: Color(0xff5E7A90)),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            difference == 1
                ? 'Вчера'
                : (difference < 1
                    ? timeago.format(widget.chat.lastMessageTime, locale: 'ru')
                    : DateFormat('d.MM.yyyy')
                        .format(widget.chat.lastMessageTime)),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              fontFamily: 'Gilray',
              color: Color(0xff5E7A90),
            ),
          ),
        ],
      ),
    );
  }
}
