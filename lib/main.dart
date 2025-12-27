import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_mate/core/cubits/theme/theme_cubit.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/routes/app_router.dart';
import 'package:social_mate/core/utils/routes/app_routes.dart';
import 'package:social_mate/core/utils/theme/app_theme.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: AppConstants.envFileName);
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: Builder(
        builder: (context) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            bloc: BlocProvider.of<ThemeCubit>(context),
            builder: (context, state) {
              return MaterialApp(
                themeAnimationCurve: Curves.linear,
                themeAnimationDuration: const Duration(milliseconds: 300),
                themeAnimationStyle: AnimationStyle(
                  curve: Curves.linear,
                  duration: const Duration(milliseconds: 300),
                ),
                debugShowCheckedModeBanner: false,
                title: AppConstants.appName,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: state,
                onGenerateRoute: AppRouter.generateRoute,
                initialRoute: AppRoutes.auhtPageRoute,
              );
            },
          );
        },
      ),
    );
  }
}
