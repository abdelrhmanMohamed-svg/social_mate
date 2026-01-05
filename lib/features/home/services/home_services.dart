import 'dart:developer';

import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_names.dart';
import 'package:social_mate/features/home/models/story_model.dart';

abstract class HomeServices {
  Future<List<StoryModel>> fetchStories();
}

class HomeServicesImpl implements HomeServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  @override
  Future<List<StoryModel>> fetchStories() async {
    try {
      final response = await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesNames.stories,
        builder: (data, id) => StoryModel.fromMap(data),
      
      );
    
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
