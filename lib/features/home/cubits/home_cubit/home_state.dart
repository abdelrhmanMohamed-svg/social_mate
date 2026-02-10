part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

// Stories States

final class StoriesLoading extends HomeState {
  final List<StoryModel> fakeStories;
  const StoriesLoading(this.fakeStories);
}

final class StoriesLoaded extends HomeState {
  final List<StoryModel> stories;
  final List<StoryModel> currentUserStories;
  final String userID;


  const StoriesLoaded({
    required this.currentUserStories,
    required this.stories,
    required this.userID,
  });
}

final class StoriesError extends HomeState {
  final String message;

  const StoriesError(this.message);
}

// posts States

final class PostsLoading extends HomeState {
  final List<PostModel> fakePosts;
  const PostsLoading(this.fakePosts);
}

final class PostsLoaded extends HomeState {
  final List<PostModel> posts;

  const PostsLoaded(this.posts);
}

final class PostsError extends HomeState {
  final String message;

  const PostsError(this.message);
}

// Add Post States
final class AddPostLoading extends HomeState {}

final class AddPostSuccess extends HomeState {}

final class AddPostError extends HomeState {
  final String message;

  const AddPostError(this.message);
}

// Current User States

final class CurrentUserLoading extends HomeState {}

final class CurrentUserLoaded extends HomeState {
  final UserModel currentUser;

  const CurrentUserLoaded(this.currentUser);
}

final class CurrentUserError extends HomeState {
  final String message;

  const CurrentUserError(this.message);
}

final class EmptyCheckState extends HomeState {
  final bool isEmpty;

  const EmptyCheckState(this.isEmpty);
}

// native states
final class ImagePickedSuccess extends HomeState {}

final class VideoPickedSuccess extends HomeState {
  final VideoPlayerController controller;

  const VideoPickedSuccess(this.controller);
}

final class FilePickedSuccess extends HomeState {}

final class MediaPickError extends HomeState {
  final String message;

  const MediaPickError(this.message);
}

// pagination states
final class PostsPaginationLoading extends HomeState {}

//

