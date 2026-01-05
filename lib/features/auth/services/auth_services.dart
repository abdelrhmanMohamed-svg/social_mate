import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_mate/core/services/supabase_database_services.dart';
import 'package:social_mate/core/utils/supabase_tables_names.dart';
import 'package:social_mate/features/auth/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthServices {
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
  Future<void> nativeGoogleSignIn(bool isSignUp);
  User? checkAuthStatus();
  Future<void> logOut();
}

class AuthServicesImpl implements AuthServices {
  final _supabase = Supabase.instance.client;
  final _googleSignIn = GoogleSignIn.instance;
  final _supabaseDatabaseServices = SupabaseDatabaseServices.instance;

  @override
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final res = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    if (res.user == null) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    final res = await _supabase.auth.signUp(email: email, password: password);
    if (res.user == null) {
      return false;
    }
    final newUser = UserModel(id: res.user!.id, name: name, email: email);
    await _supabaseDatabaseServices.insertRow(
      table: SupabaseTablesNames.users,
      values: newUser.toMap(),
    );

    return true;
  }

  @override
  Future<void> signOut() async => await _supabase.auth.signOut();

  @override
  Future<void> nativeGoogleSignIn(bool isSignUp) async {
    const webClientId =
        '74758644962-2e3t5uet7en7sjpn4k6b0elcu8g3f3mn.apps.googleusercontent.com';

    final scopes = ['email', 'profile'];

    await _googleSignIn.initialize(serverClientId: webClientId);

    final googleUser = await _googleSignIn.authenticate();

    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }

    await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
    if (isSignUp) {
      if (_supabase.auth.currentUser != null) {
        throw AuthException('User already exists.');
      }

      final newUser = UserModel(
        id: _supabase.auth.currentUser!.id,
        name: googleUser.displayName,
        email: googleUser.email,
      );

      await _supabaseDatabaseServices.insertRow(
        table: SupabaseTablesNames.users,
        values: newUser.toMap(),
      );
    }
  }

  @override
  User? checkAuthStatus() {
    return _supabase.auth.currentUser;
  }

  @override
  Future<void> logOut() async {
    await _supabase.auth.signOut();
    await _googleSignIn.signOut();
  }
}
