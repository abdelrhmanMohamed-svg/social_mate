import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/services/auth_core_services.dart';
import 'package:social_mate/features/auth/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());
  final _authCoreServices = AuthCoreServicesImpl();
  
  
  Future<void> fetchUserData() async {
    emit(FetchingUserData());
    try {
      final userData = await _authCoreServices.fetchCurrentUser();
      emit(FetchedUserData(userData));
    } catch (e) {
      emit(FetchingUserDataError(e.toString()));
    }
  }


}
