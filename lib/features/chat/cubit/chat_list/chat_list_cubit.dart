import 'package:flutter_bloc/flutter_bloc.dart';
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
        profileImageUrl: 'profileImageUrl',
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
