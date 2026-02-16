import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/services/home_services.dart';

part 'story_state.dart';

class StoryCubit extends Cubit<StoryState> {
  StoryCubit(this.vsync) : super(StoryInitial());
  final _homeServices = HomeServicesImpl();
  final _authcoreServices = AuthCoreServicesImpl();
  final TickerProvider vsync;
  late PageController pageController;
  late AnimationController animationController;
  late int currentIndex;
  Color chosenStoryColor = storyColors[0];

  int storiesLength = 0;
  void initPageController() {
    pageController = PageController();
    animationController = AnimationController(
      vsync: vsync,
      duration: Duration(seconds: 5),
    );
    currentIndex = 0;
  }

  void disposePageController() {
    pageController.dispose();
  }

  void disposeAnimationController() {
    animationController.dispose();
  }

  void stopAnimation() {
    animationController.stop();
  }

  void resetAnimation() {
    animationController
      ..reset()
      ..forward();
  }

  void setCurrentIndex(int index) {
    currentIndex = index;
    resetAnimation();
    emit(StoryPlaying(currentIndex));
  }

  void nextStory() {
    if (pageController.page! < storiesLength - 1) {
      pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStory() {
    if (storiesLength > 1 && pageController.page! > 0) {
      pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> fetchUserStories(String userId) async {
    emit(FetchUserStoriesLoading());
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      final rawUserStories = await _homeServices.fetchUserStories(userId);
      if (currentUser.id == null) {
        emit(FetchUserStoriesError("user id is null"));
        return;
      }
      final List<StoryModel> userStories = rawUserStories
          .map(
            (story) => story.copyWith(isMine: story.authorId == currentUser.id),
          )
          .toList();
      storiesLength = rawUserStories.length;
      emit(FetchUserStoriesSuccess(userStories));
    } catch (e) {
      emit(FetchUserStoriesError(e.toString()));
    }
  }

  Future<void> addStory(String text) async {
    emit(AddStoryLoading());
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      if (currentUser.id == null) {
        emit(AddStoryError("user id is null"));
        return;
      }
      await _homeServices.addStory(
        text,
        currentUser.id!,
        chosenStoryColor.toARGB32(),
      );
      emit(AddStorySuccess());
    } catch (e) {
      emit(AddStoryError(e.toString()));
    }
  }

  void setChosenStoryColor(Color color) {
    chosenStoryColor = color;
    emit(StoryColorChanged(chosenStoryColor));
  }

  Future<void> deleteStory(String storyId) async {
    emit(DeleteStoryLoading(storyId));

    try {
      await _homeServices.deleteStory(storyId);
      emit(DeleteStorySuccess(storyId));
    } catch (e) {
      emit(DeleteStoryError(e.toString()));
    }
  }
}
