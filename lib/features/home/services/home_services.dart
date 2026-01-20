import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/models/post_request_model.dart';
import 'package:social_mate/features/home/models/request_comment_model.dart';
import 'package:social_mate/features/home/models/response_comment_model.dart';
import 'package:social_mate/features/home/models/story_model.dart';

abstract class HomeServices {
  Future<List<StoryModel>> fetchStories();
 // Future<List<PostModel>> fetchPosts();
  // Future<void> addPost(PostRequestModel post);
  // Future<PostModel?> fetchPostById(String postId);
  // Future<PostModel> toggleLikePost(String postId, String userId);
  // Future<List<ResponseCommentModel>> fetchCommentsForPost(String postId);
  // Future<void> addCommentToPost({
  //   required String postId,
  //   required String text,
  //   required String authorId,
  // });
}

class HomeServicesImpl implements HomeServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  @override
  Future<List<StoryModel>> fetchStories() async {
    try {
      final response = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.stories,
        builder: (data, id) => StoryModel.fromMap(data),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }

 
}
