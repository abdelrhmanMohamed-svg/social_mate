class ChatMembersModel {
  final String chatId;
  final String userId;

  const ChatMembersModel({required this.chatId, required this.userId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'chat_id': chatId, 'user_id': userId};
  }

  factory ChatMembersModel.fromMap(Map<String, dynamic> map) {
    return ChatMembersModel(
      chatId: map['chat_id'] as String,
      userId: map['user_id'] as String,
    );
  }
}
