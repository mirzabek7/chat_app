class Message {
  final String? text;
  final String? imageUrl;
  final bool isImage;
  final DateTime sentTime;
  final String senderUid;

  Message({
    required this.text,
    required this.imageUrl,
    required this.isImage,
    required this.sentTime,
    required this.senderUid,
  });
}
