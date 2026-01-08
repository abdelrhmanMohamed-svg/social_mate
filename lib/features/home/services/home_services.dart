import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_names.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/models/post_request_model.dart';
import 'package:social_mate/features/home/models/story_model.dart';

abstract class HomeServices {
  Future<List<StoryModel>> fetchStories();
  Future<List<PostModel>> fetchPosts();
  Future<void>addPost(PostRequestModel post);
}

class HomeServicesImpl implements HomeServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  @override
  Future<List<StoryModel>> fetchStories() async {
    try {
      final response = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesNames.stories,
        builder: (data, id) => StoryModel.fromMap(data),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesNames.posts,
        builder: (data, id) => PostModel.fromMap(data),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
  
  @override
  Future<void> addPost(PostRequestModel post) {
    try {
      return _supabaseDatabaseServices.insertRow(
        table: SupabaseTablesNames.posts,
        values: post.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }
}
