import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/core/services/native_services.dart';
import 'package:social_mate/core/services/supabase_storage_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/args_models/file_args_model.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
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
  final _nativeServices = NativeServicesImpl();
  final _supabaseStorageServices = SupabaseStorageServicesImpl();
  File? imagePicked;
  File? videoPicked;
  FileArgsModel? filePicked;

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

      emit(PostsLoaded(rawPosts.reversed.toList()));
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
      await _homeServices.addPost(newPost);
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
      emit(VideoPickedSuccess());
    }
  }

  Future<void> pickVideoFromCamera() async {
    final pickedVideo = await _nativeServices.pickVideo(ImageSource.camera);
    if (pickedVideo != null) {
      videoPicked = pickedVideo;
      emit(VideoPickedSuccess());
    }
  }

  Future<void> pickFile() async {
    final pickedFile = await _nativeServices.pickFile();
    if (pickedFile != null) {
      filePicked = pickedFile;
      emit(FilePickedSuccess());
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

  void setToInitial() {
    imagePicked = null;
    videoPicked = null;
    filePicked = null;
  }
}
