import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthServices {
  Future<bool> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> signOut();
}

class AuthServicesImpl implements AuthServices {
  final supabase = Supabase.instance.client;
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
  }) async {
    final res = await supabase.auth.signUp(email: email, password: password);
    if (res.user == null) {
      return false;
    }
    return true;
  }

  @override
  Future<void> signOut() async => await supabase.auth.signOut();
}
