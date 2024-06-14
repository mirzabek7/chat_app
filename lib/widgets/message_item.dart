import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_chat_app/models/message.dart';
import 'package:test_chat_app/services/user/user_service.dart';

class MessageItem extends StatefulWidget {
  const MessageItem({
    super.key,
    required this.message,
  });
  final Message message;

  @override
  State<MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<MessageItem> {
  final currentUserUid = UserService().getCurrentUserUid();
  @override
  Widget build(BuildContext context) {
    return currentUserUid == widget.message.senderUid
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xff3CED78),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(6),
                    bottomLeft: Radius.circular(23),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 274),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.message.isImage
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(19),
                                topRight: Radius.circular(19),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                widget.message.imageUrl!,
                                width: 274,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            widget.message.text!.isNotEmpty
                                ? Text(
                                    widget.message.text!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy'),
                                  )
                                : const SizedBox(),
                            Text(
                              DateFormat('hh:mm')
                                  .format(widget.message.sentTime),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xff2B333E),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy',
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xffEDF2F6),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23),
                    bottomLeft: Radius.circular(6),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 274),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      widget.message.isImage
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(19),
                                topRight: Radius.circular(19),
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                              child: Image.network(
                                widget.message.imageUrl!,
                                width: 274,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            widget.message.text!.isNotEmpty
                                ? Text(
                                    widget.message.text!,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy'),
                                  )
                                : const SizedBox(),
                            Text(
                              DateFormat('hh:mm')
                                  .format(widget.message.sentTime),
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Color(0xff2B333E),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy',
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
