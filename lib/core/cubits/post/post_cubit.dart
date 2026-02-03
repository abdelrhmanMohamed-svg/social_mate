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
  List<PostModel> paginationPosts = [];
  int page = 1;
  int limit = 3;
  bool isFetching = false;
  bool hasReachedMax = false;

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

  Future<void> toggleSavedPost(String postId) async {
    emit(ToggleSavedPostLoading(postId));
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      final updatedPost = await _postServices.toggleSavedPost(
        postId,
        currentUser.id!,
      );
      emit(
        ToggleSavedPostSuccess(postId: postId, isSaved: updatedPost.isSaved),
      );
    } catch (e) {
      emit(ToggleSavedPostError(e.toString(), postId));
    }
  }

  Future<void> fetchSavedPosts() async {
    emit(FetchSavedPostsLoading());
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      if (currentUser.id == null) {
        emit(FetchSavedPostsError("User not found"));
        return;
      }
      final rowPosts = await _postServices.fetchSavedPosts(currentUser.id!);
      List<PostModel> savedPosts = [];
      for (var post in rowPosts) {
        post = post.copyWith(isSaved: true);
        savedPosts.add(post);
      }

      emit(FetchSavedPostsSuccess(savedPosts));
    } catch (e) {
      emit(FetchSavedPostsError(e.toString()));
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

  Future<UserModel> getCurrentUser() async {
    final currentUser = await _authcoreServices.fetchCurrentUser();
    return currentUser;
  }

  Future<void> fetchUserPosts({
    bool isPagination = false,
    String? userId,
  }) async {
    if (hasReachedMax || isFetching) return;

    emit(!isPagination ? FetchingUserPosts() : ProfilePostsPaginationLoading());

    try {
      isFetching = true;
      final currentUser = await getCurrentUser();

      final rawPosts = await _postServices.fetchPosts(
        page: page,
        limit: limit,
        userId: userId,
      );

      if (rawPosts.isEmpty) {
        emit(FetchedUserPosts(paginationPosts));
        return;
      }

      hasReachedMax = rawPosts.length < limit;
      paginationPosts.addAll(rawPosts);
      page++;

      final postIds = paginationPosts.map((post) => post.id).toList();

      final commentsMap = await _postServices.fetchCommentsForPosts(postIds);

      final posts = paginationPosts.map((post) {
        final postComments = commentsMap[post.id] ?? [];
        final isLiked = post.likes?.contains(currentUser.id) ?? false;
        final isSaved = post.saves?.contains(currentUser.id) ?? false;

        return post.copyWith(
          isLiked: isLiked,
          commentsCount: postComments.length,
          isSaved: isSaved,
        );
      }).toList();

      emit(FetchedUserPosts(posts));
    } catch (e) {
      emit(FetchingUserPostsError(e.toString()));
    }
    isFetching = false;
  }
}
