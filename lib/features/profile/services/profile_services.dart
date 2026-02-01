import 'dart:io';

import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/services/supabase_storage_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';

abstract class ProfileServices {
  Future<Map<String, dynamic>> editUserData({
    required String id,

    String? name,
    String? bio,
    String? aboutMe,
    String? workExperience,
    String? profileImageUrl,
    String? coverImageUrl,
    File? profileFile,
    File? coverFile,
  });
  Future<List<UserModel>> fetchFollowers(String currentUserId);
  Future<List<UserModel>> fetchFollowing(String currentUserId);
  Future<bool> followUser(String userId, String currentUserId);
  Future<void> unFollowUser(String userId, String currentUserId);
  Future<void> unSendRequest(String userId, String currentUserId);
}

class ProfileServicesImpl implements ProfileServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  final _supabaseStorageServices = SupabaseStorageServicesImpl();

  @override
  Future<Map<String, dynamic>> editUserData({
    required String id,

    String? name,
    String? bio,
    String? aboutMe,
    String? workExperience,
    String? profileImageUrl,
    String? coverImageUrl,
    File? profileFile,
    File? coverFile,
  }) async {
    String? profileImageUrlUrl;
    String? coverImageUrlUrl;

    try {
      if (profileImageUrl != null) {
        profileImageUrlUrl = profileImageUrl;
      }
      if (coverImageUrl != null) {
        coverImageUrlUrl = coverImageUrl;
      }
      if (profileFile != null) {
        profileImageUrlUrl = await _supabaseStorageServices.uploadFile(
          bucketName: SupabaseTablesAndBucketsNames.users,
          file: profileFile,
          filePath:
              'public/users/profileImages/$id/${DateTime.now().toIso8601String()}',
        );
      }
      if (coverFile != null) {
        coverImageUrlUrl = await _supabaseStorageServices.uploadFile(
          bucketName: SupabaseTablesAndBucketsNames.users,
          file: coverFile,
          filePath:
              'public/users/coverImages/$id/${DateTime.now().toIso8601String()}',
        );
      }
      final values = {
        "name": name,
        "bio": bio,
        "about_me": aboutMe,
        "work_experience": workExperience,
        "image_url": profileImageUrlUrl,
        "cover_image_url": coverImageUrlUrl,
      };
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        values: values,
        column: AppConstants.primaryKey,
        value: id,
      );
      return values;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> fetchFollowers(String currentUserId) async {
    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: currentUserId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      if (currentUser.followers == null) {
        return [];
      }
      if (currentUser.followers!.isEmpty) {
        return [];
      }
      final followersFutures = currentUser.followers!.map((userID) async {
        final user = await _supabaseDatabaseServices.fetchRow(
          table: SupabaseTablesAndBucketsNames.users,
          primaryKey: AppConstants.primaryKey,
          id: userID,
          builder: (data, id) => UserModel.fromMap(data),
        );
        return user;
      }).toList();
      final followers = await Future.wait(followersFutures);
      return followers;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> fetchFollowing(String currentUserId) async {
    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: currentUserId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      if (currentUser.following == null) {
        return [];
      }
      if (currentUser.following!.isEmpty) {
        return [];
      }
      final followingFutures = currentUser.following!.map((userId) async {
        final user = await _supabaseDatabaseServices.fetchRow(
          table: SupabaseTablesAndBucketsNames.users,
          primaryKey: AppConstants.primaryKey,
          id: userId,
          builder: (data, id) => UserModel.fromMap(data),
        );
        return user;
      }).toList();
      final following = await Future.wait(followingFutures);
      return following;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<bool> followUser(String userId, String currentUserId) async {
    bool isUserToFollow = false;

    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: currentUserId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final user = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: userId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final userRequestsList = List.from(user.followRequests ?? []);

      final userToFollowList = List.from(currentUser.followWating ?? []);

      userToFollowList.add(userId);
      userRequestsList.add(currentUserId);
      isUserToFollow = false;

      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        column: AppConstants.primaryKey,
        value: currentUserId,
        values: {AppConstants.followWatingColumn: userToFollowList},
      );
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        column: AppConstants.primaryKey,
        value: userId,
        values: {AppConstants.followRequestsColumn: userRequestsList},
      );
      return isUserToFollow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unFollowUser(String userId, String currentUserId) async {
    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: currentUserId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final followingList = List.from(currentUser.following ?? []).toList();
      followingList.remove(userId);
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        values: {AppConstants.followingColumn: followingList},
        column: AppConstants.primaryKey,
        value: currentUserId,
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> unSendRequest(String userId, String currentUserId) async {
    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: currentUserId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final userFollowWaitng = List.from(currentUser.followWating ?? []);
      userFollowWaitng.remove(userId);
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        values: {AppConstants.followWatingColumn: userFollowWaitng},
        column: AppConstants.primaryKey,
        value: currentUserId,
      );
    } catch (e) {
      rethrow;
    }
  }
}
