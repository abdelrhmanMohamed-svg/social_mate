part of 'story_cubit.dart';

sealed class StoryState {
  const StoryState();
}

final class StoryInitial extends StoryState {}

//fetch user stories states
final class FetchUserStoriesLoading extends StoryState {}

final class FetchUserStoriesSuccess extends StoryState {
  final List<StoryModel> stories;


  const FetchUserStoriesSuccess(this.stories);
}

final class FetchUserStoriesError extends StoryState {
  final String message;

  const FetchUserStoriesError(this.message);
}

// add story states
final class AddStoryLoading extends StoryState {}

final class AddStorySuccess extends StoryState {}

final class AddStoryError extends StoryState {
  final String error;

  const AddStoryError(this.error);
}


// story playing states
final class StoryPlaying extends StoryState {
  final int index;

  const StoryPlaying(this.index);
}

// story color changed states
final class StoryColorChanged extends StoryState {
  final Color color;

  const StoryColorChanged(this.color);
}

// delete story states
final class DeleteStoryLoading extends StoryState {
  final String storyId;

  const DeleteStoryLoading(this.storyId);


}
final class DeleteStorySuccess extends StoryState {
  final String storyId;

  const DeleteStorySuccess(this.storyId);


}
final class DeleteStoryError extends StoryState {
  final String error;

  const DeleteStoryError(this.error);
}

