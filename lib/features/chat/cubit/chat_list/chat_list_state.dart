part of 'chat_list_cubit.dart';

sealed class ChatListState {}

final class ChatListInitial extends ChatListState {}

final class ChatListLoading extends ChatListState {
  final List<InboxChatModel> fakeChats;
  ChatListLoading(this.fakeChats);
}

final class ChatListLoaded extends ChatListState {
  final List<InboxChatModel> chats;

  ChatListLoaded({required this.chats});
}

final class ChatListEmpty extends ChatListState {
  final List<UserModel> suggestedUsers;

  ChatListEmpty({required this.suggestedUsers});
}

final class ChatListError extends ChatListState {
  final String message;

  ChatListError({required this.message});
}
