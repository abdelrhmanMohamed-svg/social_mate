import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/chat/models/request_message_model.dart';
import 'package:social_mate/features/chat/models/response_message_model.dart';
import 'package:social_mate/features/chat/services/chat_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'single_chat_state.dart';

class SingleChatCubit extends Cubit<SingleChatState> {
  SingleChatCubit(this._userId) : super(SingleChatInitial());
  final ChatServices _chatServices = ChatServicesImpl();
  final _authCore = AuthCoreServicesImpl();
  final String _userId;
  RealtimeChannel? _channel;

  Future<void> initialize() async {
    try {
      emit(SingleChatLoading());

      // 1. Get or create chat ID
      final chatId = await _chatServices.getOrCreateChatId(_userId);

      // 2. Load initial messages
      final messages = await _chatServices.loadInitialMessages(chatId);
      emit(
        SingleChatLoaded(
          chatId: chatId,
          messages: messages,
          otherUserId: _userId,
        ),
      );

      // 3. Get unread count
      final unreadCount = await _chatServices.getUnreadCount(chatId);

      // 4. Mark as read if needed
      if (unreadCount > 0) {
        await _chatServices.markMessagesAsRead(chatId);
      }

      // 5. Subscribe to real-time updates
      _setupRealtimeSubscription(chatId);
    } catch (e) {
      emit(SingleChatError(message: e.toString()));
    }
  }

  void _setupRealtimeSubscription(String chatId) {
    try {
      _channel = _chatServices.subscribeToMessages(
        chatId: chatId,
        onInitialOrUpdate: (updatedMessages) {
          if (state is SingleChatLoaded) {
            final currentState = state as SingleChatLoaded;

            final Map<String, ResponseMessageModel> allMessages = {};

            for (final msg in currentState.messages) {
              allMessages[msg.id] = msg;
            }

            for (final msg in updatedMessages) {
              allMessages[msg.id] = msg;
            }

            final sortedMessages = allMessages.values.toList()
              ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

            emit(currentState.copyWith(messages: sortedMessages));
          }
        },
        onNewMessage: (newMessage) {
          if (state is SingleChatLoaded) {
            final currentState = state as SingleChatLoaded;

            final exists = currentState.messages.any(
              (msg) => msg.id == newMessage.id,
            );

            if (!exists) {
              final updatedMessages = [...currentState.messages, newMessage];
              updatedMessages.sort(
                (a, b) => a.createdAt.compareTo(b.createdAt),
              );
              emit(currentState.copyWith(messages: updatedMessages));
            }
          }
        },
        onUpdateMessage: (updatedMessage) {
          if (state is SingleChatLoaded) {
            final currentState = state as SingleChatLoaded;
            final updatedMessages = currentState.messages.map((msg) {
              return msg.id == updatedMessage.id ? updatedMessage : msg;
            }).toList();
            emit(currentState.copyWith(messages: updatedMessages));
          }
        },
        onDeleteMessage: (deletedId) {
          if (state is SingleChatLoaded) {
            final currentState = state as SingleChatLoaded;
            final updatedMessages = currentState.messages
                .where((msg) => msg.id != deletedId)
                .toList();
            emit(currentState.copyWith(messages: updatedMessages));
          }
        },
      );
    } catch (e) {
      log('Error setting up subscription: $e');
      if (state is SingleChatLoaded) {
        final currentState = state as SingleChatLoaded;
        emit(currentState.copyWith(error: 'Real-time connection issue'));
      }
    }
  }

  Future<void> sendMessage(String content) async {
    try {
      if (state is! SingleChatLoaded) return;
      final currentUser = await getCurrentUser();
      if (currentUser.id == null) return;

      final currentState = state as SingleChatLoaded;
      final chatId = currentState.chatId;

      final message = RequestMessageModel(
        chatId: chatId,
        content: content,
        senderId: currentUser.id!,
      );

      await _chatServices.sendMessage(message);
    } catch (e) {
      emit(SingleChatError(message: 'Failed to send message: $e'));
    }
  }

  Future<UserModel> getCurrentUser() async {
    return await _authCore.fetchCurrentUser();
  }

  Future<void> loadMoreMessages() async {
    try {
      if (state is! SingleChatLoaded) return;

      final currentState = state as SingleChatLoaded;
      if (currentState.messages.isEmpty) return;

      final oldestMessage = currentState.messages.first;
      final beforeDate = oldestMessage.createdAt;

      final olderMessages = await _chatServices.loadMoreMessages(
        currentState.chatId,
        beforeDate: beforeDate,
      );

      if (olderMessages.isEmpty) {
        emit(currentState.copyWith(hasReachedMax: true));
      } else {
        final updatedMessages = [...olderMessages, ...currentState.messages];
        emit(
          currentState.copyWith(
            messages: updatedMessages,
            isLoadingMore: false,
          ),
        );
      }
    } catch (e) {
      if (state is SingleChatLoaded) {
        final currentState = state as SingleChatLoaded;
        emit(currentState.copyWith(isLoadingMore: false));
      }
    }
  }

  // get other user data
  Future<void> fetchOtherUserData(String userId) async {
    try {
      emit(SingleChatOtherUserLoading());

      final otherUser = await _authCore.fetchUserById(userId);

      emit(SingleChatOtherUserLoaded(otherUser: otherUser));
    } catch (e) {
      emit(SingleChatError(message: 'Failed to fetch other user data: $e'));
    }
  }

  @override
  Future<void> close() async {
    if (_channel != null) {
      await _chatServices.unsubscribe(_channel!);
    }
    return super.close();
  }
}
