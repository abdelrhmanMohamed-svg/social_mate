// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:social_mate/features/auth/models/user_model.dart';

class InboxChatModel {
  final String chatId;
  final UserModel otherUser;
  final String? lastMessage;
  final String? lastMessageAt;
  final int unreadCount;
  const InboxChatModel({
    required this.chatId,
    required this.otherUser,
    this.lastMessage,
    this.lastMessageAt,
    this.unreadCount=0,
  });

 

  InboxChatModel copyWith({
    String? chatId,
    UserModel? otherUser,
    String? lastMessage,
    String? lastMessageAt,
    int? unreadCount,
  }) {
    return InboxChatModel(
      chatId: chatId ?? this.chatId,
      otherUser: otherUser ?? this.otherUser,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
