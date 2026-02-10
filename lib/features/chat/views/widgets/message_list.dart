import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_mate/features/chat/models/response_message_model.dart';
import 'package:social_mate/features/chat/views/widgets/message_bubble.dart';

class MessageList extends StatelessWidget with SU {
  const MessageList({
    super.key,
    required this.messages,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final List<ResponseMessageModel> messages;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final reversedMessages = messages.reversed.toList();
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoadingMore &&
            scrollInfo.metrics.pixels >=
                scrollInfo.metrics.maxScrollExtent - 100) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.builder(
        reverse: true,
        padding: EdgeInsets.all(16.w),
        itemCount: reversedMessages.length + (isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == reversedMessages.length) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          final message = reversedMessages[index];
          return MessageBubble(message: message);
        },
      ),
    );
  }
}
