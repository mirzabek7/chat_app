class Chats {
  final String chatUid;
  final String userAName;
  final String userAUid;
  final String userBName;
  final String userBUid;
  final String lastMessageSenderUid;
  final String lastMessage;
  final DateTime lastMessageTime;

  Chats({
    required this.chatUid,
    required this.userAName,
    required this.userAUid,
    required this.userBName,
    required this.userBUid,
    required this.lastMessage,
    required this.lastMessageSenderUid,
    required this.lastMessageTime,
  });
}
