import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';

abstract class DiscoverServices {
  Future<List<UserModel>> fetchUsers(String id);
  Future<bool> followUser(String userId, String currentUserId);
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

  @override
  Future<bool> followUser(String userId, String currentUserId) async {
    bool isUserToFollow = false;

    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: 'id',
        id: currentUserId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final user = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: 'id',
        id: userId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final userRequestsList = List.from(user.followRequests ?? []).toList();

      final userToFollowList = List.from(
        currentUser.followWating ?? [],
      ).toList();
      if (userToFollowList.contains(userId)) {
        userToFollowList.remove(userId);
        userRequestsList.remove(currentUserId);

        isUserToFollow = true;
      } else {
        userToFollowList.add(userId);
        userRequestsList.add(currentUserId);
        isUserToFollow = false;
      }
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        column: 'id',
        value: currentUserId,
        values: {'follow_wating': userToFollowList},
      );
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        column: 'id',
        value: userId,
        values: {'follow_requets': userRequestsList},
      );
      return isUserToFollow;
    } catch (e) {
      rethrow;
    }
  }
}
