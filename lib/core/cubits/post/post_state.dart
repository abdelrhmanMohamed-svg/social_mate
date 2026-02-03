part of 'post_cubit.dart';

sealed class PostState {
  const PostState();
}

final class PostInitial extends PostState {}

// posts States

final class PostsLoading extends PostState {}

final class PostsLoaded extends PostState {
  final List<PostModel> posts;

  const PostsLoaded(this.posts);
}

final class PostsError extends PostState {
  final String message;

  const PostsError(this.message);
}

// Fetch Comments States
final class FetchCommentsLoading extends PostState {}

final class FetchCommentsSuccess extends PostState {
  final List<ResponseCommentModel> comments;

  const FetchCommentsSuccess(this.comments);
}

// fetch post likes
final class FetchLikesLoading extends PostState {}

final class FetchLikesSuccess extends PostState {
  final List<UserModel> likedUsers;

  const FetchLikesSuccess(this.likedUsers);
}

final class FetchLikesError extends PostState {
  final String message;

  const FetchLikesError(this.message);
}

final class FetchCommentsError extends PostState {
  final String message;

  const FetchCommentsError(this.message);
}

// Toggle Like Post States
final class ToggleLikePostLoading extends PostState {
  final String postId;

  const ToggleLikePostLoading(this.postId);
}

final class ToggleLikePostSuccess extends PostState {
  final String postId;
  final bool isLiked;
  final int likeCount;

  const ToggleLikePostSuccess({
    required this.postId,
    required this.isLiked,
    required this.likeCount,
  });
}

final class ToggleLikePostError extends PostState {
  final String postId;
  final String message;

  const ToggleLikePostError(this.message, this.postId);
}

// Toggle Saved Post States
final class ToggleSavedPostLoading extends PostState {
  final String postId;

  const ToggleSavedPostLoading(this.postId);
}

final class ToggleSavedPostSuccess extends PostState {
  final String postId;
  final bool isSaved;

  const ToggleSavedPostSuccess({required this.postId, required this.isSaved});
}

final class ToggleSavedPostError extends PostState {
  final String postId;
  final String message;

  const ToggleSavedPostError(this.message, this.postId);
}

// fetch post states
final class FetchSavedPostsLoading extends PostState {}

final class FetchSavedPostsSuccess extends PostState {
  final List<PostModel> posts;

  const FetchSavedPostsSuccess(this.posts);
}

final class FetchSavedPostsError extends PostState {
  final String message;
  const FetchSavedPostsError(this.message);
}

// Add Comment States
final class AddCommentLoading extends PostState {}

final class AddCommentSuccess extends PostState {}

final class AddCommentError extends PostState {
  final String message;

  const AddCommentError(this.message);
}

// file states

final class OpenFileLoading extends PostState {}

final class OpenFileSuccess extends PostState {}

final class OpenFileError extends PostState {
  final String message;

  const OpenFileError(this.message);
}

final class DownloadFileLoading extends PostState {}

final class DownloadFileSuccess extends PostState {}

final class DownloadFileError extends PostState {
  final String message;

  const DownloadFileError(this.message);
}

final class VideoPickedSuccess extends PostState {
  final VideoPlayerController controller;

  const VideoPickedSuccess(this.controller);
}

//current user posts stats

final class FetchingUserPosts extends PostState {}

final class FetchedUserPosts extends PostState {
  final List<PostModel> posts;

  const FetchedUserPosts(this.posts);
}

final class FetchingUserPostsError extends PostState {
  final String message;

  const FetchingUserPostsError(this.message);
}

final class ProfilePostsPaginationLoading extends PostState {}
