import 'package:social_mate/features/auth/models/user_model.dart';

class PublicProfileArgs {
  final UserModel user;
  final bool isPublic;
  PublicProfileArgs({required this.user, required this.isPublic});
}
