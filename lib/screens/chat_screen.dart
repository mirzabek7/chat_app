import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_chat_app/chat_icons.dart';
import 'package:test_chat_app/models/chat.dart';
import 'package:test_chat_app/models/message.dart';
import 'package:test_chat_app/services/chat/chat_service.dart';
import 'package:test_chat_app/services/user/user_service.dart';
import 'package:test_chat_app/widgets/image_selection.dart';

import '../widgets/message_item.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen(
      this.chat, this.nickname, this.otherUserName, this.randomColor,
      {super.key});
  final Chats chat;
  final String nickname;
  final String otherUserName;
  final Color randomColor;
  static const routeName = '/chat';

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  File? _image;
  Future<void> sentMessage() async {
    final chatServ = Provider.of<ChatService>(context, listen: false);
    await chatServ.sendMessage(
      widget.chat.chatUid,
      _controller.text,
      _image,
    );
    _controller.clear();
    if (_image != null) {
      setState(() {
        _image = null;
      });
    }
  }

  void _takeImage(File image) {
    setState(() {
      _image = image;
      print(_image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatserv = Provider.of<ChatService>(context);
    final otherUser = Provider.of<UserService>(context);
    final currentUserUid = UserService().getCurrentUserUid();
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Chat.btn,
                    color: Color(0xff2B333E),
                    size: 36,
                  ),
                ),
                CircleAvatar(
                  backgroundColor: widget.randomColor,
                  radius: 34,
                  child: Text(
                    widget.nickname,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.otherUserName,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy'),
                    ),
                    StreamBuilder(
                      stream: otherUser.userStatus(
                          currentUserUid == widget.chat.userAUid
                              ? widget.chat.userBUid
                              : widget.chat.userAUid),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          bool status = snapshot.data!['isOnline'];
                          return Text(
                            status ? 'В сети' : 'Оффлайн',
                            style: const TextStyle(
                              color: Color(0xff5E7A90),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Gilroy',
                            ),
                          );
                        } else {
                          return const Text(
                            'Оффлайн',
                            style: TextStyle(
                              color: Color(0xff5E7A90),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Gilroy',
                            ),
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          leadingWidth: double.infinity,
        ),
        body: Stack(
          children: [
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              bottom: _image != null ? 150 : 100,
              child: StreamBuilder(
                stream: chatserv.getMessages(widget.chat.chatUid),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    final messages = snapshot.data!.docs;
                    return ListView.builder(
                      reverse: true,
                      itemCount: messages.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      itemBuilder: (ctx, index) {
                        final time = messages[index]['sentTime'] as Timestamp;
                        final message = Message(
                          text: messages[index]['text'],
                          imageUrl: messages[index]['imageUrl'],
                          isImage: messages[index]['isImage'],
                          sentTime: time.toDate(),
                          senderUid: messages[index]['senderUid'],
                        );
                        return MessageItem(
                          message: message,
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    height: 1,
                    color: Color(0xffEDF2F6),
                  ),
                  if (_image != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          width: 50,
                          fit: BoxFit.cover,
                          height: 50,
                        ),
                      ),
                    )
                  else
                    const SizedBox(),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _image != null ? 6 : 14,
                        left: 20,
                        right: 20,
                        bottom: 34.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ImageSelection(
                          takeImage: _takeImage,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            decoration: InputDecoration(
                              filled: true,
                              isCollapsed: true,
                              fillColor: const Color(0xffEDF2F6),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                  color: Color(0xffEDF2F6),
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: Color(0xffEDF2F6))),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 24),
                              hintText: 'Поиск',
                              hintStyle: const TextStyle(
                                  color: Color(0xff9DB7CB),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Gilray'),
                            ),
                            autofocus: false,
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: const Color(0xffEDF2F6),
                              borderRadius: BorderRadius.circular(12)),
                          child: IconButton(
                            padding: const EdgeInsets.all(6),
                            onPressed: () {
                              sentMessage();
                            },
                            icon: const Icon(
                              Icons.send,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
