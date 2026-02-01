import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/home/models/request_story_model.dart';
import 'package:social_mate/features/home/models/story_model.dart';

abstract class HomeServices {
  Future<List<StoryModel>> fetchStories();
  Future<List<StoryModel>> fetchUserStories(String userId);

  Future<void> addStory(String text, String currentUserID, int color);
  Future<void> deleteStory(String storyId);
}

class HomeServicesImpl implements HomeServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  final _authcoreServices = AuthCoreServicesImpl();

  @override
  Future<List<StoryModel>> fetchStories() async {
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      if (currentUser.id == null) {
        throw Exception("user id is null");
      }
      final response = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.stories,
        builder: (data, id) => StoryModel.fromMap(data),
        filter: (query) =>
            query.neq(AppConstants.authorIdColumn, currentUser.id!),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addStory(String text, String currentUserID, int color) async {
    try {
      final newStory = RequestStoryModel(
        txt: text,
        authorId: currentUserID,
        color: color,
      );
      await _supabaseDatabaseServices.insertRow(
        table: SupabaseTablesAndBucketsNames.stories,
        values: newStory.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<StoryModel>> fetchUserStories(String userId) async {
    try {
      return await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.stories,
        builder: (data, id) => StoryModel.fromMap(data),
        filter: (query) => query.eq(AppConstants.authorIdColumn, userId),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteStory(String storyId) async {
    try {
      await _supabaseDatabaseServices.deleteRow(
        table: SupabaseTablesAndBucketsNames.stories,
        column: AppConstants.primaryKey,
        value: storyId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
