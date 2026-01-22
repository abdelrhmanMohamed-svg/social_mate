import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/services/native_services.dart';
import 'package:social_mate/core/services/post_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/models/response_comment_model.dart';
import 'package:video_player/video_player.dart';

part 'post_state.dart';

class PostCubit extends Cubit<PostState> {
  PostCubit() : super(PostInitial());
  final _postServices = PostServicesImpl();
  final _authcoreServices = AuthCoreServicesImpl();
  final _nativeServices = NativeServicesImpl();
  VideoPlayerController? _controller;

  // Posts Services

  Future<void> toggleLikePost(String postId) async {
    emit(ToggleLikePostLoading(postId));
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      final updatedPost = await _postServices.toggleLikePost(
        postId,
        currentUser.id!,
      );
      emit(
        ToggleLikePostSuccess(
          postId: postId,
          isLiked: updatedPost.isLiked,
          likeCount: updatedPost.likes?.length ?? 0,
        ),
      );
    } catch (e) {
      emit(ToggleLikePostError(e.toString(), postId));
    }
  }

  // Comments Services
  Future<void> addComment(String text, String postId) async {
    emit(AddCommentLoading());
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();

      await _postServices.addCommentToPost(
        postId: postId,
        text: text,
        authorId: currentUser.id!,
      );
      emit(AddCommentSuccess());
    } catch (e) {
      emit(AddCommentError(e.toString()));
    }
  }

  Future<void> fetchCommentsForPost(String postId) async {
    emit(FetchCommentsLoading());
    try {
      final comments = await _postServices.fetchCommentsForPost(postId);
      List<ResponseCommentModel> editComments = [];
      for (var comment in comments) {
        final author = await _authcoreServices.fetchUserById(comment.authorId);
        comment = comment.copyWith(
          authorName: author.name,
          authorImage: author.profileImageUrl,
        );
        editComments.add(comment);
      }
      emit(FetchCommentsSuccess(editComments));
    } catch (e) {
      emit(FetchCommentsError(e.toString()));
    }
  }

  Future<void> fetchLikesForPost(String postId) async {
    emit(FetchLikesLoading());
    try {
      final post = await _postServices.fetchPostById(postId);
      if (post == null) {
        emit(FetchLikesError("Post not found"));
        return;
      }
      List<UserModel> likedUsers = [];
      for (var userId in post.likes ?? []) {
        final user = await _authcoreServices.fetchUserById(userId);
        likedUsers.add(user);
      }
      emit(FetchLikesSuccess(likedUsers));
    } catch (e) {
      emit(FetchLikesError(e.toString()));
    }
  }

  Future<void> downloadFile(String fileUrl, String fileName) async {
    emit(DownloadFileLoading());
    try {
      await _nativeServices.downloadFile(fileUrl, fileName);
      emit(DownloadFileSuccess());
    } catch (e) {
      emit(DownloadFileError(e.toString()));
    }
  }

  void togglePlay([VideoPlayerController? controller]) {
    if (controller != null) {
      _controller = controller;
    }
    if (_controller == null) return;

    _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();

    emit(VideoPickedSuccess(_controller!));
  }

  Future<void> fetchUserPosts([String? userId]) async {
    emit(FetchingUserPosts());
    try {
      final userData = userId != null
          ? await _authcoreServices.fetchUserById(userId)
          : await _authcoreServices.fetchCurrentUser();

      final rawposts = await _postServices.fetchPosts(userData.id);
      List<PostModel> posts = [];
      for (var post in rawposts) {
        final currentUser = await _authcoreServices.fetchCurrentUser();
        final postComments = await _postServices.fetchCommentsForPost(post.id);

        final isLiked = post.likes?.contains(currentUser.id) ?? false;
        post = post.copyWith(
          isLiked: isLiked,
          commentsCount: postComments.length,
        );
        posts.add(post);
      }

      emit(FetchedUserPosts(posts));
    } catch (e) {
      emit(FetchingUserPostsError(e.toString()));
    }
  }
}
