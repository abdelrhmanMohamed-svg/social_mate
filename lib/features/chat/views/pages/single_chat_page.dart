import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/core/views/widgets/custom_snack_bar.dart';
import 'package:social_mate/features/chat/cubit/single_chat/single_chat_cubit.dart';
import 'package:social_mate/features/chat/views/widgets/message_input.dart';
import 'package:social_mate/features/chat/views/widgets/message_list.dart';
import 'package:social_mate/features/chat/views/widgets/other_user_header_section.dart';

class SingleChatPage extends StatelessWidget {
  final String otherUserId;

  const SingleChatPage({super.key, required this.otherUserId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SingleChatCubit(otherUserId),
      child: _SingleChatView(otherUserId: otherUserId),
    );
  }
}

class _SingleChatView extends StatefulWidget with SU {
  const _SingleChatView({required this.otherUserId});
  final String otherUserId;

  @override
  State<_SingleChatView> createState() => _SingleChatViewState();
}

class _SingleChatViewState extends State<_SingleChatView> {
  late SingleChatCubit _singleChatCubit;
  @override
  void initState() {
    super.initState();
    _singleChatCubit = context.read<SingleChatCubit>();
    _singleChatCubit.fetchOtherUserData(widget.otherUserId);
    _singleChatCubit.initialize();
  }

  @override
  Widget build(BuildContext context) {
    final singleChatCubit = context.read<SingleChatCubit>();
    return Scaffold(
      appBar: AppBar(leadingWidth: 40.w, title: OtherUserHeaderSection()),
      body: BlocConsumer<SingleChatCubit, SingleChatState>(
        bloc: singleChatCubit,
        buildWhen: (previous, current) =>
            current is SingleChatLoading ||
            current is SingleChatLoaded ||
            current is SingleChatError,
        listenWhen: (previous, current) => current is SingleChatError,
        listener: (context, state) {
          if (state is SingleChatError) {
            showCustomSnackBar(context, state.message, isError: true);
          }
        },
        builder: (context, state) {
          if (state is SingleChatLoading) {
            return Expanded(
              child: MessageList(
                messages: state.fakeMessages,
                isLoadingMore: false,
                onLoadMore: () {},
                isLoading: true,
              ),
            );
          }

          if (state is SingleChatError) {
            return Center(child: Text('Error: ${state.message}'));
          }

          if (state is SingleChatLoaded) {
            return Column(
              children: [
                Expanded(
                  child: MessageList(
                    messages: state.messages,
                    isLoadingMore: state.isLoadingMore,
                    onLoadMore: () {
                      singleChatCubit.loadMoreMessages();
                    },
                  ),
                ),

                // Message Input
                MessageInput(
                  onSend: (message) {
                    singleChatCubit.sendMessage(message);
                  },
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
