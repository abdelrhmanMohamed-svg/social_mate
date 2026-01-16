import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/models/post_request_model.dart';
import 'package:social_mate/features/home/models/request_comment_model.dart';
import 'package:social_mate/features/home/models/response_comment_model.dart';
import 'package:social_mate/features/home/models/story_model.dart';

abstract class HomeServices {
  Future<List<StoryModel>> fetchStories();
  Future<List<PostModel>> fetchPosts();
  Future<void> addPost(PostRequestModel post);
  Future<PostModel?> fetchPostById(String postId);
  Future<PostModel> toggleLikePost(String postId, String userId);
  Future<List<ResponseCommentModel>> fetchCommentsForPost(String postId);
  Future<void> addCommentToPost({
    required String postId,
    required String text,
    required String authorId,
  });
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

  @override
  Future<List<PostModel>> fetchPosts() async {
    try {
      final response = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.posts,
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
        table: SupabaseTablesAndBucketsNames.posts,
        values: post.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PostModel> toggleLikePost(String postId, String userId) async {
    bool isLiked = false;
    try {
      var post = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.posts,
        primaryKey: ' id ',
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );

      final likes = List<String>.from(post.likes ?? []);
      if (likes.contains(userId)) {
        likes.remove(userId);
        isLiked = false;
      } else {
        likes.add(userId);
        isLiked = true;
      }
      post = post.copyWith(likes: likes);

      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.posts,
        column: 'id',
        value: postId,
        values: post.toMap(),
      );

      return post.copyWith(isLiked: isLiked);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> addCommentToPost({
    required String postId,
    required String text,
    required String authorId,
  }) async {
    try {
      final newComment = RequestCommentModel(
        text: text,
        postId: postId,
        authorId: authorId,
      );
      await _supabaseDatabaseServices.insertRow(
        table: SupabaseTablesAndBucketsNames.comments,
        values: newComment.toMap(),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ResponseCommentModel>> fetchCommentsForPost(String postId) async {
    try {
      return await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.comments,
        filter: (query) => query.eq('post_id', postId),
        builder: (data, id) => ResponseCommentModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PostModel?> fetchPostById(String postId) async {
    try {
      return await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.posts,
        primaryKey: ' id ',
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
