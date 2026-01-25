import 'dart:io';

import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/services/supabase_storage_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';

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
}
