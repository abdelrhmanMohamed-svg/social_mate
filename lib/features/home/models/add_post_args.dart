import 'package:social_mate/features/home/cubits/home_cubit/home_cubit.dart';

class AddPostArgs {
  final HomeCubit homeCubit;
  final bool openCameraDirectly;
  final bool openGalleryDirectly;
  final bool openVideoDirectly;

  const AddPostArgs({
    required this.homeCubit,
    this.openCameraDirectly = false,
    this.openGalleryDirectly = false,
    this.openVideoDirectly = false,
  });
}
