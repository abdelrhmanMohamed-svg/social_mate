import 'package:flutter/rendering.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/chat/models/chat_members_model.dart';
import 'package:social_mate/features/chat/models/inbox_chat_model.dart';
import 'package:social_mate/features/chat/models/request_message_model.dart';
import 'package:social_mate/features/chat/models/response_message_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ChatServices {
  Future<List<UserModel>> getSuggestedUsers();
  Future<List<InboxChatModel>> getInboxChats();
  Future<List<ResponseMessageModel>> loadMoreMessages(
    String chatId, {
    required DateTime beforeDate,
    int limit = 50,
  });
  Future<int> getUnreadCount(String chatId);
  Future<void> markMessagesAsRead(String chatId);

  Future<String> getOrCreateChatId(String otherUserId);
  Future<void> sendMessage(RequestMessageModel message);
  RealtimeChannel subscribeToMessages({
    required String chatId,
    required void Function(List<ResponseMessageModel> updatedMessages)
    onInitialOrUpdate,
    required void Function(ResponseMessageModel newMessage) onNewMessage,
    required void Function(ResponseMessageModel updatedMessage) onUpdateMessage,
    required void Function(String deletedId) onDeleteMessage,
  });
  Future<void> unsubscribe(RealtimeChannel channel);
  Future<List<ResponseMessageModel>> loadInitialMessages(String chatId);
}

class ChatServicesImpl implements ChatServices {
  final _db = SupabaseDatabaseServices.instance;
  final supabase = Supabase.instance.client;
  final _authCore = AuthCoreServicesImpl();

  @override
  RealtimeChannel subscribeToMessages({
    required String chatId,
    required void Function(List<ResponseMessageModel> updatedMessages)
    onInitialOrUpdate,
    required void Function(ResponseMessageModel newMessage) onNewMessage,
    required void Function(ResponseMessageModel updatedMessage) onUpdateMessage,
    required void Function(String deletedId) onDeleteMessage, // اختياري
  }) {
    try {
      final channel = supabase.channel('messages:$chatId');

      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: SupabaseTablesAndBucketsNames.publicSchema,
        table: SupabaseTablesAndBucketsNames.messages,
        filter: PostgresChangeFilter(
          type: PostgresChangeFilterType.eq,
          column: AppConstants.chatIdColumn,
          value: chatId,
        ),
        callback: (payload) {
          final changeType = payload.eventType;

          final newRecord = payload.newRecord;
          final oldRecord = payload.oldRecord;

          if (changeType == PostgresChangeEvent.insert) {
            final msg = ResponseMessageModel.fromMap(
              map: newRecord,
              myUserId: supabase.auth.currentUser?.id ?? '',
            );
            onNewMessage(msg);
          } else if (changeType == PostgresChangeEvent.update) {
            final msg = ResponseMessageModel.fromMap(
              map: newRecord,
              myUserId: supabase.auth.currentUser?.id ?? '',
            );
            onUpdateMessage(msg);
          } else if (changeType == PostgresChangeEvent.delete) {
            final deletedId = oldRecord[AppConstants.primaryKey]?.toString();
            if (deletedId != null) {
              onDeleteMessage(deletedId);
            }
          }
        },
      );

      channel.subscribe((status, [error]) {
        if (status == RealtimeSubscribeStatus.subscribed) {
          debugPrint('Subscribed to messages for chat: $chatId');
        } else if (status == RealtimeSubscribeStatus.closed) {
          debugPrint('Channel closed');
        }
      });

      return channel;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unsubscribe(RealtimeChannel channel) async {
    try {
      await channel.unsubscribe();
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> sendMessage(RequestMessageModel message) async {
    try {
      await _db.insertRow(
        table: SupabaseTablesAndBucketsNames.messages,
        values: message.toMap(),
      );
      await _db.updateRow(
        table: SupabaseTablesAndBucketsNames.chats,
        column: AppConstants.primaryKey,
        value: message.chatId,
        values: {
          AppConstants.lastMessageContentColumn: message.content,
          AppConstants.lastMessageAtColumn: DateTime.now().toIso8601String(),
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ResponseMessageModel>> loadInitialMessages(String chatId) async {
    try {
      return await _db.fetchRowsWithTransform(
        table: SupabaseTablesAndBucketsNames.messages,
        filter: (query) => query.eq(AppConstants.chatIdColumn, chatId),
        transform: (query) => query
            .order(AppConstants.createdAtColumn, ascending: true)
            .limit(50),
        builder: (data, id) => ResponseMessageModel.fromMap(
          map: data,
          myUserId: supabase.auth.currentUser?.id ?? '',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> getOrCreateChatId(String otherUserId) async {
    try {
      final currentUserId = supabase.auth.currentUser!.id;
      final myChats = await _db.fetchRows(
        table: SupabaseTablesAndBucketsNames.chatMembers,
        builder: (data, id) => ChatMembersModel.fromMap(data),
        filter: (query) => query.eq(AppConstants.userIdColumn, currentUserId),
      );

      final chatIds = myChats.map((chat) => chat.chatId).toList();

      if (chatIds.isNotEmpty) {
        final exists = await _db.fetchRows(
          table: SupabaseTablesAndBucketsNames.chatMembers,
          builder: (data, id) => ChatMembersModel.fromMap(data),
          filter: (query) => query
              .inFilter(AppConstants.chatIdColumn, chatIds)
              .eq(AppConstants.userIdColumn, otherUserId),
        );

        if (exists.isNotEmpty) {
          return exists.first.chatId;
        }
      }

      final newChatResponse = await _db.insertRowWithReturn(
        table: SupabaseTablesAndBucketsNames.chats,
        values: {},
      );

      final chatId = newChatResponse[AppConstants.primaryKey] as String;
      await Future.wait([
        _db.insertRow(
          table: SupabaseTablesAndBucketsNames.chatMembers,
          values: ChatMembersModel(
            chatId: chatId,
            userId: currentUserId,
          ).toMap(),
        ),
        _db.insertRow(
          table: SupabaseTablesAndBucketsNames.chatMembers,
          values: ChatMembersModel(chatId: chatId, userId: otherUserId).toMap(),
        ),
      ]);

      return chatId;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<InboxChatModel>> getInboxChats() async {
    final userId = supabase.auth.currentUser!.id;
    try {
      // Step 1: Get all chat IDs for current user
      final userChatsResponse = await _db.fetchRows(
        table: SupabaseTablesAndBucketsNames.chatMembers,
        builder: (data, id) => ChatMembersModel.fromMap(data),
        filter: (query) => query.eq(AppConstants.userIdColumn, userId),
      );
      final chatIds = userChatsResponse.map((chat) => chat.chatId).toList();
      if (chatIds.isEmpty) return [];
      // Step 2: Get chats with members info
      final response = await supabase
          .from(SupabaseTablesAndBucketsNames.chats)
          .select('''
          id,
          last_message,
          last_message_at,
          chat_members!inner(
            user_id,
            users!inner(
              id,
              name,
              email,
              image_url,
              bio
            )
          )
        ''')
          .inFilter(AppConstants.primaryKey, chatIds)
          .order(AppConstants.lastMessageAtColumn, ascending: false);
      // Process the data
      final List<InboxChatModel> inboxChats = [];

      for (final chatData in response) {
        final members = chatData['chat_members'] as List;

        final otherMemberData = members.firstWhere(
          (m) => m['user_id'] != userId,
          orElse: () => null,
        );
        if (otherMemberData == null) continue;

        final otherUserData = otherMemberData['users'];
        inboxChats.add(
          InboxChatModel(
            chatId: chatData['id'],
            otherUser: UserModel.fromMap(otherUserData),
            lastMessage: chatData['last_message'] ?? '',
            lastMessageAt: chatData['last_message_at'],
          ),
        );
      }

      return inboxChats;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getUnreadCount(String chatId) async {
    try {
      final userId = supabase.auth.currentUser!.id;

      return await _db.countRows(
        table: SupabaseTablesAndBucketsNames.messages,
        filter: (query) => query
            .eq(AppConstants.chatIdColumn, chatId)
            .eq(AppConstants.isReadColumn, false)
            .neq(AppConstants.senderIdColumn, userId),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      await _db.updateRow(
        table: SupabaseTablesAndBucketsNames.messages,
        column: AppConstants.isReadColumn,
        value: false,
        values: {AppConstants.isReadColumn: true},
        filter: (query) => query
            .eq(AppConstants.chatIdColumn, chatId)
            .neq(AppConstants.senderIdColumn, userId)
            .eq(AppConstants.isReadColumn, false),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ResponseMessageModel>> loadMoreMessages(
    String chatId, {
    required DateTime beforeDate,
    int limit = 50,
  }) async {
    try {
      return await _db.fetchRowsWithTransform(
        table: SupabaseTablesAndBucketsNames.messages,
        filter: (query) => query
            .eq(AppConstants.chatIdColumn, chatId)
            .lt(AppConstants.createdAtColumn, beforeDate.toIso8601String()),
        transform: (query) => query
            .order(AppConstants.createdAtColumn, ascending: false)
            .limit(limit),
        builder: (data, id) => ResponseMessageModel.fromMap(
          map: data,
          myUserId: supabase.auth.currentUser?.id ?? '',
        ),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getSuggestedUsers() async {
    try {
      final currentUser = await _authCore.fetchCurrentUser();

      final followersIds = currentUser.followers;
      if (followersIds == null || followersIds.isEmpty) {
        return [];
      }

      final currentUserId = currentUser.id;
      final followingIds = currentUser.following ?? [];

      final validIds = followersIds
          .where((id) => id != currentUserId && !followingIds.contains(id))
          .toList();

      if (validIds.isEmpty) return [];

      return await _db.fetchRowsWithTransform(
        table: SupabaseTablesAndBucketsNames.users,
        builder: (data, id) => UserModel.fromMap(data),
        filter: (query) => query.inFilter(AppConstants.primaryKey, validIds),
        transform: (query) => query.limit(20),
      );
    } catch (e) {
      rethrow;
    }
  }
}
