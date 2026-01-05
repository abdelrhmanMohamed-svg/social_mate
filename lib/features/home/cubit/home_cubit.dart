import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/services/home_services.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final _storiesServices = HomeServicesImpl();
  final _authcoreServices = AuthCoreServicesImpl();

  Future<void> fetchStories() async {
    emit(StoriesLoading());
    try {
      final rawStories = await _storiesServices.fetchStories();
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
}
