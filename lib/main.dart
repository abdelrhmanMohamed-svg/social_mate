import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:social_mate/core/cubits/localization/localization_cubit.dart';
import 'package:social_mate/core/cubits/post/post_cubit.dart';
import 'package:social_mate/core/cubits/theme/theme_cubit.dart';
import 'package:social_mate/core/models/route_observer.dart';
import 'package:social_mate/core/services/fcm_services.dart';
import 'package:social_mate/core/utils/app_constants.dart';
import 'package:social_mate/core/utils/app_keys.dart';
import 'package:social_mate/core/utils/routes/app_router.dart';
import 'package:social_mate/core/utils/theme/app_theme.dart';
import 'package:social_mate/features/auth/auth_cubit/auth_cubit.dart';
import 'package:social_mate/features/auth/views/pages/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'generated/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: AppConstants.envFileName);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  FcmServicesImpl.instance.setNavigatorKey(AppKeys.navigatorKey);

  await FcmServicesImpl.instance.initialize();
  await FcmServicesImpl.instance.startListeningForTokenChanges();

  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorageDirectory.web
        : HydratedStorageDirectory((await getTemporaryDirectory()).path),
  );
  await ScreenUtil.ensureScreenSize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit()..checkAuthStatus()),
        BlocProvider(create: (context) => ThemeCubit()),
        BlocProvider(create: (context) => PostCubit()),
        BlocProvider(create: (context) => LocalizationCubit()),
      ],
      child: Builder(
        builder: (context) {
          return ScreenUtilInit(
            designSize: const Size(428, 926),
            minTextAdapt: true,
            builder: (_, child) {
              return BlocBuilder<ThemeCubit, ThemeMode>(
                bloc: BlocProvider.of<ThemeCubit>(context),
                builder: (context, themeState) {
                  return BlocBuilder<LocalizationCubit, Locale>(
                    bloc: BlocProvider.of<LocalizationCubit>(context),
                    builder: (context, localeState) {
                      return MaterialApp(
                        locale: localeState,
                        localizationsDelegates: [
                          S.delegate,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate,
                          GlobalCupertinoLocalizations.delegate,
                        ],
                        supportedLocales: S.delegate.supportedLocales,
                        navigatorKey: AppKeys.navigatorKey,
                        navigatorObservers: [RouteObserverModel()],
                        themeAnimationCurve: Curves.linear,
                        themeAnimationDuration: const Duration(
                          milliseconds: 300,
                        ),
                        themeAnimationStyle: AnimationStyle(
                          curve: Curves.linear,
                          duration: const Duration(milliseconds: 300),
                        ),
                        debugShowCheckedModeBanner: false,
                        title: AppConstants.appName,
                        theme: AppTheme.lightTheme,
                        darkTheme: AppTheme.darkTheme,
                        themeMode: themeState,
                        onGenerateRoute: AppRouter.generateRoute,
                        home: child,
                      );
                    },
                  );
                },
              );
            },
            child: const AuthGate(),
          );
        },
      ),
    );
  }
}
