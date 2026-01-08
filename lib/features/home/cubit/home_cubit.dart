import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/models/post_request_model.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final _homeServices = HomeServicesImpl();
  final _authcoreServices = AuthCoreServicesImpl();
  String? imageUrl;
  String? videoUrl;

  // Stories Services
  Future<void> fetchStories() async {
    emit(StoriesLoading());
    try {
      final rawStories = await _homeServices.fetchStories();
      final users = await _authcoreServices.fetchUsers();
      final List<StoryModel> updatedStoreis = [];
      for (var story in rawStories) {
        final authorName = users
            .firstWhere((user) => user.id == story.authorId)
            .name;
        story = story.copyWith(authorName: authorName);
        updatedStoreis.add(story);
      }

      emit(StoriesLoaded(updatedStoreis));
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }

  // Posts Services
  Future<void> fetchPosts() async {
    emit(PostsLoading());
    try {
      final rawPosts = await _homeServices.fetchPosts();
      emit(PostsLoaded(rawPosts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
  }

  void checkIsEmpty(String value) {
    emit(EmptyCheckState(value.isEmpty));
  }

  Future<void> addPost(String content) async {
    emit(AddPostLoading());
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();

      final newPost = PostRequestModel(
        content: content,
        authorId: currentUser.id!,
        imageUrl: imageUrl,
        videoUrl: videoUrl,
        authorName: currentUser.name!,
        authorImage:
            currentUser.profileImageUrl ?? AppConstants.userIMagePLaceholder,
      );
      await _homeServices.addPost(newPost);
      emit(AddPostSuccess());
    } catch (e) {
      emit(AddPostError(e.toString()));
    }
  }

  // Current User Services
  Future<void> fetchCurrentUser() async {
    emit(CurrentUserLoading());
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      emit(CurrentUserLoaded(currentUser));
    } catch (e) {
      emit(CurrentUserError(e.toString()));
    }
  }

  Future<void> refresh() async {
    Future.wait([fetchStories(), fetchPosts()]);
  }
}
