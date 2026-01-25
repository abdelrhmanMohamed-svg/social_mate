import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/supabase_tables_and_buckets_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';

abstract class FollowRequestServices {
  Stream<List<UserModel>> usersStream();
  Future<void> acceptFollowRequest({
    required String senderId,
    required String myId,
  });

  Future<void> rejectFollowRequest({
    required String senderId,
    required String myId,
  });
}

class FollowRequestServicesImpl implements FollowRequestServices {
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;
  @override
  Stream<List<UserModel>> usersStream() {
    try {
      return _supabaseDatabaseServices.tableStream(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: [AppConstants.primaryKey],
        builder: (data, id) => UserModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> acceptFollowRequest({
    required String senderId,
    required String myId,
  }) async {
    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: myId,
        builder: (data, id) => UserModel.fromMap(data),
      );

      final sender = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: senderId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final followersList = List.from(currentUser.followers ?? []);
      followersList.add(senderId);

      final followingList = List.from(sender.following ?? []);
      followingList.add(myId);
      final followRequestsList = List.from(currentUser.followRequests ?? []);
      followRequestsList.remove(senderId);
      final followWaitingList = List.from(sender.followWating ?? []);
      followWaitingList.remove(myId);
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        value: myId,
        column: AppConstants.primaryKey,
        values: {
          AppConstants.followersColumn: followersList,

          AppConstants.followRequestsColumn: followRequestsList,
        },
      );
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        value: senderId,
        column: AppConstants.primaryKey,
        values: {
         AppConstants.followingColumn : followingList,
          AppConstants.followWatingColumn: followWaitingList,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> rejectFollowRequest({
    required String senderId,
    required String myId,
  }) async {
    try {
      final currentUser = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: myId,
        builder: (data, id) => UserModel.fromMap(data),
      );

      final sender = await _supabaseDatabaseServices.fetchRow(
        table: SupabaseTablesAndBucketsNames.users,
        primaryKey: AppConstants.primaryKey,
        id: senderId,
        builder: (data, id) => UserModel.fromMap(data),
      );
      final followRequestsList = List.from(currentUser.followRequests ?? []);
      followRequestsList.remove(senderId);
      final followWaitingList = List.from(sender.followWating ?? []);
      followWaitingList.remove(myId);
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        value: myId,
        column: AppConstants.primaryKey,
        values: {AppConstants.followRequestsColumn: followRequestsList},
      );
      await _supabaseDatabaseServices.updateRow(
        table: SupabaseTablesAndBucketsNames.users,
        value: senderId,
        column: AppConstants.primaryKey,
        values: {AppConstants.followWatingColumn: followWaitingList},
      );
    } catch (e) {
      rethrow;
    }
  }
}
