import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/chat/models/inbox_chat_model.dart';
import 'package:social_mate/features/chat/services/chat_services.dart';

part 'chat_list_state.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListInitial());
  final ChatServices _chatServices = ChatServicesImpl();
  final List<InboxChatModel> fakeChats = List.filled(
    4,
    InboxChatModel(
      chatId: 'chatId',
      lastMessage: 'lastMessage',
      lastMessageAt: '2026-02-09 23:06:56.41787+00',
      otherUser: UserModel(
        id: 'id',
        name: 'name',
        email: 'email',
        profileImageUrl: AppConstants.userIMagePLaceholder,
      ),
    ),
  );
  Future<void> loadChats() async {
    try {
      emit(ChatListLoading(fakeChats));

      final chats = await _chatServices.getInboxChats();
      if (chats.isEmpty) {
        final suggestedUsers = await _chatServices.getSuggestedUsers();
        emit(ChatListEmpty(suggestedUsers: suggestedUsers));
      } else {
        emit(ChatListLoaded(chats: chats));
      }
    } catch (e) {
      emit(ChatListError(message: e.toString()));
    }
  }

  Future<void> setReadMessages(String? chatID) async {
    if (chatID == null) return;
    try {
      await _chatServices.markMessagesAsRead(chatID);
      if (state is ChatListLoaded) {
        final currentState = state as ChatListLoaded;
        final updatedChats = currentState.chats.map((chat) {
          if (chat.chatId == chatID) {
            return chat.copyWith(unreadCount: 0);
          }
          return chat;
        }).toList();
        emit(ChatListLoaded(chats: updatedChats));
      }
    } catch (e) {
      if (state is ChatListLoaded) {
        final currentState = state as ChatListLoaded;
        emit(ChatListLoaded(chats: currentState.chats));
      } else {
        emit(ChatListError(message: e.toString()));
      }
    }
  }

  Future<void> refreshChats() async {
    try {
      final chats = await _chatServices.getInboxChats();

      emit(ChatListLoaded(chats: chats));
    } catch (e) {
      if (state is ChatListLoaded) {
        emit(ChatListLoaded(chats: (state as ChatListLoaded).chats));
      } else {
        emit(ChatListError(message: e.toString()));
      }
    }
  }
}
