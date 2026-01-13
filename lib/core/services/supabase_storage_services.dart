import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

abstract class SupabaseStorageServices {
  Future<String> uploadFile({
    required File file,
    required String filePath,
    required String bucketName,
  });
  
}

class SupabaseStorageServicesImpl implements SupabaseStorageServices {
  final _supabaseClient = Supabase.instance.client;

  @override
  Future<String> uploadFile({
    required File file,
    required String filePath,
    required String bucketName,
  }) async {
    try {
      await   _supabaseClient.storage
          .from(bucketName)
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(cacheControl: '3600', upsert: true),
          );

      final publicUrl = _supabaseClient.storage
          .from(bucketName)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      rethrow;
    }
  }
}
