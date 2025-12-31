import 'package:google_sign_in/google_sign_in.dart';
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
  final supabase = Supabase.instance.client;
  final googleSignIn = GoogleSignIn.instance;
  @override
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final res = await supabase.auth.signInWithPassword(
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
    final res = await supabase.auth.signUp(email: email, password: password);
    if (res.user == null) {
      return false;
    }
    await supabase.from('users').insert({
      'name': name,
      'email': email,
      'id': res.user!.id,
    });
    return true;
  }

  @override
  Future<void> signOut() async => await supabase.auth.signOut();

  @override
  Future<void> nativeGoogleSignIn(bool isSignUp) async {
    const webClientId =
        '74758644962-2e3t5uet7en7sjpn4k6b0elcu8g3f3mn.apps.googleusercontent.com';

    final scopes = ['email', 'profile'];

    await googleSignIn.initialize(serverClientId: webClientId);

    final googleUser = await googleSignIn.authenticate();

    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);

    final idToken = googleUser.authentication.idToken;

    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }

    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );
    if (isSignUp) {
      if (supabase.auth.currentUser != null) {
        throw AuthException('User already exists.');
      }
      await supabase.from('users').insert({
        'name': googleUser.displayName,
        'email': googleUser.email,
        'id': supabase.auth.currentUser!.id,
      });
    }
  }

  @override
  User? checkAuthStatus() {
    return supabase.auth.currentUser;
  }

  @override
  Future<void> logOut() async {
    await supabase.auth.signOut();
    await googleSignIn.signOut();
  }
}
