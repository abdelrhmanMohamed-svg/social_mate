class ResponseMessageModel {
  const ResponseMessageModel({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.isMine,
    required this.senderId,
    required this.chatId,
    required this.isRead,
  });

  final String id;

  final String content;

  final DateTime createdAt;

  final bool isMine;
  final String senderId;
  final String chatId;
  final bool isRead;

  ResponseMessageModel.fromMap({
    required Map<String, dynamic> map,
    required String myUserId,
  }) : id = map['id'],
       senderId = map['sender_id'],
       content = map['content'],
       createdAt = DateTime.parse(map['created_at']),
       isMine = myUserId == map['sender_id'],
       chatId = map['chat_id'],
       isRead = map['is_read'] ?? false;
       
}
