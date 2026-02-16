import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/services/native_services.dart';
import 'package:social_mate/core/services/post_services.dart';
import 'package:social_mate/core/services/supabase_storage_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/args_models/file_args_model.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/home/models/post_model.dart';
import 'package:social_mate/features/home/models/post_request_model.dart';
import 'package:social_mate/features/home/models/story_model.dart';
import 'package:social_mate/features/home/services/home_services.dart';
import 'package:video_player/video_player.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  final _homeServices = HomeServicesImpl();
  final _authcoreServices = AuthCoreServicesImpl();
  final _nativeServices = NativeServicesImpl();
  final _supabaseStorageServices = SupabaseStorageServicesImpl();
  final _postServices = PostServicesImpl();

  File? imagePicked;
  File? videoPicked;
  FileArgsModel? filePicked;
  VideoPlayerController? _controller;
  int page = 0;
  int limit = 3;
  bool hasReachedMax = false;
  bool isFetching = false;
  List<PostModel> paginationPosts = [];
  List<StoryModel> fakeStories = List.filled(
    4,
    StoryModel(
      id: '1',
      createdAt: "2026-01-13 23:23:35.758314+00",
      authorId: "authorId",
      color: 22,
      imageUrl: 'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
    ),
  );
  List<PostModel> fakePosts = List.filled(
    4,
    PostModel(
      id: '1',
      content: "content",
      authorId: "authorId",
      createdAt: "2026-01-13 23:23:35.758314+00",
      imageUrl: 'https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d',
    ),
  );

  // Posts Services
  Future<void> fetchPosts({
    bool isPagination = false,
    bool isReset = false,
  }) async {
    if (isReset) {
      page = 0;
      paginationPosts.clear();
      hasReachedMax = false;
      isFetching = false;
    }
    if (hasReachedMax || isFetching) return;

    emit(!isPagination ? PostsLoading(fakePosts) : PostsPaginationLoading());

    try {
      isFetching = true;
      final currentUser = await getCurrentUser();

      final rawPosts = await _postServices.fetchPosts(page: page, limit: limit);

      if (rawPosts.isEmpty) {
        emit(PostsLoaded(paginationPosts));
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
        final isMyPost = post.authorId == currentUser.id;

        return post.copyWith(
          isLiked: isLiked,
          commentsCount: postComments.length,
          isSaved: isSaved,
          isMyPost: isMyPost,
        );
      }).toList();

      emit(PostsLoaded(posts));
    } catch (e) {
      emit(PostsError(e.toString()));
    }
    isFetching = false;
  }

  Future<UserModel> getCurrentUser() async {
    final currentUser = await _authcoreServices.fetchCurrentUser();
    return currentUser;
  }

  Future<void> addPost(String content) async {
    emit(AddPostLoading());
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();

      final newPost = PostRequestModel(
        content: content,
        authorId: currentUser.id!,

        imageUrl: imagePicked != null
            ? await _supabaseStorageServices.uploadFile(
                file: imagePicked!,
                filePath:
                    'public/posts/images/${currentUser.id!}/${DateTime.now().toIso8601String()}',
                bucketName: SupabaseTablesAndBucketsNames.supabasePostsBucket,
              )
            : null,
        videoUrl: videoPicked != null
            ? await _supabaseStorageServices.uploadFile(
                file: videoPicked!,
                filePath:
                    'public/posts/videos/${currentUser.id!}/${DateTime.now().toIso8601String()}',
                bucketName: SupabaseTablesAndBucketsNames.supabasePostsBucket,
              )
            : null,
        fileUrl: filePicked != null
            ? await _supabaseStorageServices.uploadFile(
                file: File(filePicked!.filePath),
                filePath:
                    'public/posts/files/${currentUser.id!}/${DateTime.now().toIso8601String()}',
                bucketName: SupabaseTablesAndBucketsNames.supabasePostsBucket,
              )
            : null,
        fileName: filePicked?.fileName,

        authorName: currentUser.name!,
        authorImage:
            currentUser.profileImageUrl ?? AppConstants.userIMagePLaceholder,
      );
      await _postServices.addPost(newPost);
      emit(AddPostSuccess());
    } catch (e) {
      emit(AddPostError(e.toString()));
    }
  }

  // Native Services
  Future<void> pickImageFromGallery() async {
    final pickedImage = await _nativeServices.pickImage(ImageSource.gallery);
    if (pickedImage != null) {
      imagePicked = pickedImage;
      emit(ImagePickedSuccess());
    }
  }

  Future<void> pickImageFromCamera() async {
    final pickedImage = await _nativeServices.pickImage(ImageSource.camera);
    if (pickedImage != null) {
      imagePicked = pickedImage;
      emit(ImagePickedSuccess());
    }
  }

  Future<void> pickVideoFromGallery() async {
    final pickedVideo = await _nativeServices.pickVideo(ImageSource.gallery);
    if (pickedVideo != null) {
      videoPicked = pickedVideo;
      await _controller?.dispose();
      _controller = VideoPlayerController.file(File(videoPicked!.path));
      await _controller!.initialize();
      await _controller!.play();
      _controller!.setLooping(true);

      emit(VideoPickedSuccess(_controller!));
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

  @override
  Future<void> close() async {
    await _controller?.dispose();
    return super.close();
  }

  Future<void> pickFile() async {
    final pickedFile = await _nativeServices.pickFile();
    if (pickedFile != null) {
      filePicked = pickedFile;
      emit(FilePickedSuccess());
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
    Future.wait([fetchHomeStories(), fetchPosts(isReset: true)]);
  }

  void setToInitial() {
    imagePicked = null;
    videoPicked = null;
    filePicked = null;
  }

  void checkIsEmpty(String value) {
    emit(EmptyCheckState(value.isEmpty));
  }

  // Stories Services
  Future<void> fetchHomeStories() async {
    emit(StoriesLoading(fakeStories));
    try {
      final currentUser = await _authcoreServices.fetchCurrentUser();
      if (currentUser.id == null) {
        emit(StoriesError("user id is null"));
        return;
      }
      final rawStories = await _homeServices.fetchStories();
      final users = await _authcoreServices.fetchUsers();
      final Map<String, UserModel> usersMap = {
        for (var user in users) user.id!: user,
      };

      final List<StoryModel> currentUserStoriesList = [];
      final Map<String, List<StoryModel>> storiesByAuthor = {};

      for (var story in rawStories) {
        final author = usersMap[story.authorId];
        final authorName = author?.name ?? 'Unknown';
        var storyWithAuthor = story.copyWith(authorName: authorName);

        if (story.authorId == currentUser.id) {

          currentUserStoriesList.add(storyWithAuthor);
        } else {
          if (!storiesByAuthor.containsKey(story.authorId)) {
            storiesByAuthor[story.authorId] = [];
          }
          storiesByAuthor[story.authorId]!.add(storyWithAuthor);
        }
      }

      emit(
        StoriesLoaded(
          storiesByAuthor: storiesByAuthor,
          lengthOfStories:
              storiesByAuthor.length +
              (currentUserStoriesList.isNotEmpty ? 1 : 0),
          userID: currentUser.id!,
          currentUserStories: currentUserStoriesList,
        ),
      );
    } catch (e) {
      emit(StoriesError(e.toString()));
    }
  }
}
