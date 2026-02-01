import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';

class AddStoryModelArgs {
  final HomeCubit cubit;
  final String? userID;

  AddStoryModelArgs( {required this.cubit, this.userID});
}
