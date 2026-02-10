class ChatModel {
  final String id;
  final String createdAt;
  final String? lastMessageContent;
  final String? lastMessageAt;
  const ChatModel({
    required this.id,
    required this.createdAt,
    this.lastMessageContent,
    this.lastMessageAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'created_at': createdAt,
      'last_message': lastMessageContent,
      'last_message_at': lastMessageAt,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as String,
      createdAt: map['created_at'] as String,
      lastMessageContent: map['last_message'] as String?,
      lastMessageAt: map['last_message_at'] as String?,
    );
  }
}
