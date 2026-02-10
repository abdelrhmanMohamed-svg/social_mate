import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_colors.dart';
import 'package:social_mate/core/utils/theme/app_text_styles.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/chat/cubit/chat_list/chat_list_cubit.dart';
import 'package:social_mate/features/chat/models/inbox_chat_model.dart';
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
      appBar: AppBar(title: Text('Chats')),
      body: BlocBuilder<ChatListCubit, ChatListState>(
        bloc: chatListCubit,
        buildWhen: (previous, current) =>
            current is ChatListLoading ||
            current is ChatListLoaded ||
            current is ChatListEmpty ||
            current is ChatListError,
        builder: (context, state) {
          if (state is ChatListLoading) {
            return Center(child: CircularProgressIndicator.adaptive());
          } else if (state is ChatListEmpty) {
            final suggestedUsers = state.suggestedUsers;
            if (suggestedUsers.isEmpty) {
              return Center(
                child: Text(
                  'No chats yet. Start following users to see them here!',
                  style: AppTextStyles.lMedium.copyWith(color: AppColors.gray),
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

            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatListItem(chat: chat);
              },
            );
          } else if (state is ChatListError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return SizedBox.shrink();
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
    if (chat == null && user != null) {
      return Card(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
          child: ListTile(
            leading: CircleAvatar(
              radius: 28.r,
              backgroundImage: NetworkImage(
                user?.profileImageUrl ?? AppConstants.userIMagePLaceholder,
              ),
            ),
            title: Text(
              user?.name ?? 'Unknown',
              style: AppTextStyles.headingH6.copyWith(color: AppColors.black87),
            ),
            subtitle: Text(
              user?.bio ?? 'No messages yet',
              style: AppTextStyles.mMedium.copyWith(color: AppColors.gray),
            ),
            trailing: Text(
              "Start Chat",
              style: AppTextStyles.mMedium.copyWith(color: AppColors.primary),
            ),
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.singleChatPageRoute, arguments: user!.id);
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
        color: AppColors.white,
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
              style: AppTextStyles.headingH6.copyWith(color: AppColors.black87),
            ),
            subtitle: Text(
              chat!.lastMessage ?? 'No messages yet',
              style: AppTextStyles.mMedium.copyWith(color: AppColors.gray),
            ),
            trailing: Text(
              chat!.lastMessageAt != null
                  ? timeago.format(lastMessageDateTime, locale: 'en_short')
                  : 'Now',
              style: AppTextStyles.mMedium.copyWith(color: AppColors.black45),
            ),

            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.singleChatPageRoute,
                arguments: chat!.otherUser.id,
              );
            },
          ),
        ),
      );
    }
    return SizedBox.shrink();
  }
}
