import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/chat/cubit/chat_list/chat_list_cubit.dart';
import 'package:social_mate/features/chat/models/inbox_chat_model.dart';
import 'package:social_mate/generated/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatListPage extends StatelessWidget with SU {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = ChatListCubit();
        cubit.loadChats();
        return cubit;
      },
      child: ChatListBody(),
    );
  }
}

class ChatListBody extends StatelessWidget {
  const ChatListBody({super.key});

  @override
  Widget build(BuildContext context) {
    final chatListCubit = context.read<ChatListCubit>();
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).chatsTitle)),
      body: BlocBuilder<ChatListCubit, ChatListState>(
        bloc: chatListCubit,
        buildWhen: (previous, current) =>
            current is ChatListLoading ||
            current is ChatListLoaded ||
            current is ChatListEmpty ||
            current is ChatListError,
        builder: (context, state) {
          if (state is ChatListLoading) {
            return _ListOfChats(chats: state.fakeChats, isLoading: true);
          } else if (state is ChatListEmpty) {
            final suggestedUsers = state.suggestedUsers;
            if (suggestedUsers.isEmpty) {
              return Center(
                child: Text(
                  'No chats yet. Start following users to see them here!',
                  style: AppTextStyles.lMedium.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: suggestedUsers.length,
              itemBuilder: (context, index) {
                final suggestedUser = suggestedUsers[index];
                return ChatListItem(user: suggestedUser);
              },
            );
          } else if (state is ChatListLoaded) {
            final chats = state.chats;

            return _ListOfChats(chats: chats);
          } else if (state is ChatListError) {
            return Center(
              child: Text('${S.of(context).errorPrefix} ${state.message}'),
            );
          }
          return SizedBox.shrink();
        },
      ),
    );
  }
}

class _ListOfChats extends StatelessWidget {
  const _ListOfChats({required this.chats, this.isLoading = false});

  final List<InboxChatModel> chats;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: isLoading,

      child: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ChatListItem(chat: chat);
        },
      ),
    );
  }
}

class ChatListItem extends StatelessWidget with SU {
  const ChatListItem({super.key, this.chat, this.user})
    : assert(
        chat != null || user != null,
        'Either chat or user must be provided',
      );

  final InboxChatModel? chat;
  final UserModel? user;

  @override
  Widget build(BuildContext context) {
    final chatListCubit = context.read<ChatListCubit>();

    if (chat == null && user != null) {
      return Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.gray,
              radius: 28.r,
              backgroundImage: NetworkImage(
                user?.profileImageUrl ?? AppConstants.userIMagePLaceholder,
              ),
            ),
            title: Text(
              user?.name ?? 'Unknown',
              style: AppTextStyles.headingH6.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              user?.bio ?? 'No messages yet',
              style: AppTextStyles.mMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            trailing: Text(
              "Start Chat",
              style: AppTextStyles.mMedium.copyWith(color: AppColors.primary),
            ),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoutes.singleChatPageRoute, arguments: user!.id)
                  .then((_) async {
                    await chatListCubit.setReadMessages(user!.id);
                  });
            },
          ),
        ),
      );
    } else if (user == null && chat != null) {
      final lastMessageTime = chat!.lastMessageAt;
      final lastMessageDateTime = DateTime.parse(
        lastMessageTime ?? DateTime.now().toIso8601String(),
      );

      return Card(
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: ListTile(
            leading: CircleAvatar(
              radius: 28.r,
              backgroundImage: NetworkImage(
                chat!.otherUser.profileImageUrl ??
                    AppConstants.userIMagePLaceholder,
              ),
            ),
            title: Text(
              chat!.otherUser.name ?? 'Unknown',
              style: AppTextStyles.headingH6.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Row(
              children: [
                Text(
                  chat!.lastMessage ?? 'No messages yet',
                  style: AppTextStyles.headingH6.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                10.horizontalSpace,
                if (chat!.unreadCount > 0)
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      chat!.unreadCount.toString(),
                      style: AppTextStyles.mMedium.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Text(
              chat!.lastMessageAt != null
                  ? timeago.format(lastMessageDateTime, locale: 'en_short')
                  : 'Now',
              style: AppTextStyles.mMedium.copyWith(
                color: Theme.of(
                  context,
                ).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),

            onTap: () {
              Navigator.of(context)
                  .pushNamed(
                    AppRoutes.singleChatPageRoute,
                    arguments: chat!.otherUser.id,
                  )
                  .then((_) async {
                    await chatListCubit.setReadMessages(chat!.chatId);
                  });
            },
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
