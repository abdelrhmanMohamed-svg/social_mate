import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';

abstract class DiscoverServices {
  Future<List<UserModel>> fetchUsers(String id);
}

class DiscoverServicesImpl implements DiscoverServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  @override
  Future<List<UserModel>> fetchUsers(String id) async {
    try {
      return await _supabaseDatabaseServices.fetchRows(
        table: SupabaseTablesAndBucketsNames.users,
        builder: (data, id) => UserModel.fromMap(data),
        filter: (query) => query.neq('id', id),
      );
    } catch (e) {
      rethrow;
    }
  }
}
