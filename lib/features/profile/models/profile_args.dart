import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';

class ProfileArgs {
  final UserModel userData;
  final ProfileCubit profileCubit;

  ProfileArgs({required this.userData, required this.profileCubit});
}
