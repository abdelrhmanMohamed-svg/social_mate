import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/models/post_request_model.dart';
import 'package:social_mate/features/home/models/request_comment_model.dart';
import 'package:social_mate/features/home/models/response_comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class PostServices {
  Future<List<PostModel>> fetchPosts({
    required int page,
    int limit = 3,
    String? userId,
  });
  Future<void> addPost(PostRequestModel post);
  Future<PostModel?> fetchPostById(String postId);
  Future<List<PostModel>> fetchSavedPosts(String userId);
  Future<PostModel> toggleLikePost(String postId, String userId);
  Future<PostModel> toggleSavedPost(String postId, String userId);

  Future<List<ResponseCommentModel>> fetchCommentsForPost(String postId);
  Future<void> addCommentToPost({
    required String postId,
    required String text,
    required String authorId,
  });
  Future<List<PostModel>> fetchUserPosts(String userId);
  Future<Map<String, List<ResponseCommentModel>>> fetchCommentsForPosts(
    List<String> postIds,
  );
  Future<void> deletePost(String postId);
}

class PostServicesImpl implements PostServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  PostgrestFilterBuilder<dynamic>? filter(
    PostgrestFilterBuilder<dynamic> query,
  ) {
    return query;
  }

  @override
  Future<List<PostModel>> fetchPosts({
    required int page,
    int limit = 3,
    String? userId,
  }) {
    final from = page * limit;
    final to = from + limit - 1;

    return _supabaseDatabaseServices.fetchRowsWithTransform(
      table: SupabaseTablesAndBucketsNames.posts,
      primaryKey: AppConstants.primaryKey,
      builder: (data, id) => PostModel.fromMap(data),

      // WHERE
      filter: (query) {
        if (userId != null) {
          return query.eq(AppConstants.authorIdColumn, userId);
        }
        return query;
      },

      // ORDER + PAGINATION
      transform: (query) {
        return query
            .order(AppConstants.createdAtColumn, ascending: false)
            .range(from, to);
      },
    );
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
        primaryKey: AppConstants.primaryKey,
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
        column: AppConstants.primaryKey,
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
        filter: (query) => query.eq(AppConstants.postIdColumn, postId),
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
        primaryKey: AppConstants.primaryKey,
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> fetchUserPosts(String userId) async {
    try {
      return await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.posts,
        filter: (query) => query.eq(AppConstants.authorIdColumn, userId),
        builder: (data, id) => PostModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<PostModel> toggleSavedPost(String postId, String userId) async {
    bool isSaved = false;
    try {
      var post = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.posts,
        primaryKey: AppConstants.primaryKey,
        id: postId,
        builder: (data, id) => PostModel.fromMap(data),
      );

      final saves = List<String>.from(post.saves ?? []);
      if (saves.contains(userId)) {
        saves.remove(userId);
        isSaved = false;
      } else {
        saves.add(userId);
        isSaved = true;
      }
      post = post.copyWith(saves: saves);

      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.posts,
        column: AppConstants.primaryKey,
        value: postId,
        values: post.toMap(),
      );

      return post.copyWith(isSaved: isSaved);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<PostModel>> fetchSavedPosts(String userId) async {
    try {
      final posts = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.posts,
        builder: (data, id) => PostModel.fromMap(data),
      );
      return posts
          .where((post) => post.saves?.contains(userId) ?? false)
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  @override
  @override
  Future<Map<String, List<ResponseCommentModel>>> fetchCommentsForPosts(
    List<String> postIds,
  ) async {
    try {
      final filterString = postIds.map((id) => 'post_id.eq.$id').join(',');

      final comments = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.comments,
        filter: (query) => query.or(filterString),
        builder: (data, id) => ResponseCommentModel.fromMap(data),
      );

      final Map<String, List<ResponseCommentModel>> commentsMap = {};

      for (var comment in comments) {
        final postId = comment.postId;
        if (commentsMap.containsKey(postId)) {
          commentsMap[postId]!.add(comment);
        } else {
          commentsMap[postId] = [comment];
        }
      }

      return commentsMap;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deletePost(String postId) async {
    try {
      await _supabaseDatabaseServices.deleteRow(
        table: SupabaseTablesAndBucketsNames.posts,
        column: AppConstants.primaryKey,
        value: postId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
