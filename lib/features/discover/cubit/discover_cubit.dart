import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/discover/services/discover_services.dart';

part 'discover_state.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit() : super(DiscoverInitial());
  final _discoverServices = DiscoverServicesImpl();
  final _authCoreServices = AuthCoreServicesImpl();

  Future<void> fetchUsers() async {
    emit(FetchUsersLoading());
    try {
      final user = await _authCoreServices.fetchCurrentUser();
      if (user.id == null) {
        emit(FetchUsersFailure('User not found'));
        return;
      }
      final users = await _discoverServices.fetchUsers(user.id!);
      emit(FetchUsersSuccess(users));
    } catch (e) {
      emit(FetchUsersFailure(e.toString()));
    }
  }
}
