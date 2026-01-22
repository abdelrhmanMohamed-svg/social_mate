import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/profile/cubit/profile_cubit.dart';

class EditProfileArgs {
  final UserModel userData;
  final ProfileCubit profileCubit;

  EditProfileArgs({required this.userData, required this.profileCubit});
}
