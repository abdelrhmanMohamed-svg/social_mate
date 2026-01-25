import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:social_mate/features/followRequest/cubit/follow_request_cubit.dart';

class FollowRequestArgs {
  final FollowRequestCubit cubit;
  final List<UserModel> users;

  FollowRequestArgs(this.cubit, this.users);
}
