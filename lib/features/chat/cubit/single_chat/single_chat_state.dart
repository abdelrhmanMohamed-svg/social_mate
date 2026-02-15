part of 'single_chat_cubit.dart';

sealed class SingleChatState {
  const SingleChatState();
}

final class SingleChatInitial extends SingleChatState {}

final class SingleChatLoading extends SingleChatState {
  final List<ResponseMessageModel> fakeMessages;
  const SingleChatLoading(this.fakeMessages);
}

class SingleChatLoaded extends SingleChatState {
  final String chatId;
  final String otherUserId;
  final List<ResponseMessageModel> messages;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? error;

  const SingleChatLoaded({
    required this.chatId,
    required this.otherUserId,
    required this.messages,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.error,
  });

  SingleChatLoaded copyWith({
    String? chatId,
    String? otherUserId,
    List<ResponseMessageModel>? messages,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? error,
  }) {
    return SingleChatLoaded(
      chatId: chatId ?? this.chatId,
      otherUserId: otherUserId ?? this.otherUserId,
      messages: messages ?? this.messages,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      error: error,
    );
  }
}

final class SingleChatError extends SingleChatState {
  final String message;

  const SingleChatError({required this.message});
}

// get other user data state
final class SingleChatOtherUserLoading extends SingleChatState {}

final class SingleChatOtherUserLoaded extends SingleChatState {
  final UserModel otherUser;

  const SingleChatOtherUserLoaded({required this.otherUser});
}

final class SingleChatOtherUserError extends SingleChatState {
  final String message;

  const SingleChatOtherUserError({required this.message});
}

