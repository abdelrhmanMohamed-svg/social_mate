import 'package:social_mate/features/auth/models/user_model.dart';

class InboxChatModel {
  final String chatId;
  final UserModel otherUser;
  final String? lastMessage;
  final String? lastMessageAt;
  const InboxChatModel({
    required this.chatId,
    required this.otherUser,
    this.lastMessage,
    this.lastMessageAt,
  });

 
}
