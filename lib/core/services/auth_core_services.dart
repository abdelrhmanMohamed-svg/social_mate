import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthCoreServices {
  Future<UserModel> fetchCurrentUser();
  Future<List<UserModel>> fetchUsers();
}

class AuthCoreServicesImpl implements AuthCoreServices {
  final _supabase = Supabase.instance.client;
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  @override
  Future<UserModel> fetchCurrentUser() async {
  try {
      return await _supabaseDatabaseServices.fetchRow(
      table: SupabaseTablesNames.users,
      primaryKey: "id",
      id: _supabase.auth.currentUser!.id,
      builder: (data, id) => UserModel.fromMap(data),
    );
  } catch (e) {
    rethrow;
  }
  }

  @override
  Future<List<UserModel>> fetchUsers() async {
    try {
       return await _supabaseDatabaseServices.fetchRows(
      table: SupabaseTablesNames.users,
      builder: (data, id) => UserModel.fromMap(data),
    );
    } catch (e) {
      rethrow;
    }
  }
}
