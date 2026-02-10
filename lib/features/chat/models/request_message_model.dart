class RequestMessageModel {
  final String content;
  final String senderId;
  final String chatId;

  const RequestMessageModel({
    required this.content,
    required this.senderId,
    required this.chatId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'content': content,
      'sender_id': senderId,
      'chat_id': chatId,
    };
  }
}
