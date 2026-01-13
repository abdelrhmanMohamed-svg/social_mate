part of 'home_cubit.dart';

sealed class HomeState {
  const HomeState();
}

final class HomeInitial extends HomeState {}

// Stories States

final class StoriesLoading extends HomeState {}

final class StoriesLoaded extends HomeState {
  final List<StoryModel> stories;

  const StoriesLoaded(this.stories);
}

final class StoriesError extends HomeState {
  final String message;

  const StoriesError(this.message);
}

// posts States

final class PostsLoading extends HomeState {}

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

final class VideoPickedSuccess extends HomeState {}

final class FilePickedSuccess extends HomeState {}

final class MediaPickError extends HomeState {
  final String message;

  const MediaPickError(this.message);
}

final class OpenFileLoading extends HomeState {}

final class OpenFileSuccess extends HomeState {}

final class OpenFileError extends HomeState {
  final String message;

  const OpenFileError(this.message);
}
final class DownloadFileLoading extends HomeState {}
final class DownloadFileSuccess extends HomeState {}
final class DownloadFileError extends HomeState {
  final String message;

  const DownloadFileError(this.message);
}
