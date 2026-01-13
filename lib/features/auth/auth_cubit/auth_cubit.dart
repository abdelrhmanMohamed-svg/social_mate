import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/features/auth/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authServices = AuthServicesImpl();
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    emit(AuthLoading());
    try {
      final res = await authServices.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );
      if (res) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Something went wrong"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    emit(AuthLoading());
    try {
      final res = await authServices.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (res) {
        emit(AuthSuccess());
      } else {
        emit(AuthFailure("Something went wrong"));
      }
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> signOut() async {
    await authServices.signOut();
    emit(AuthSignOut());
  }

  Future<void> nativeGoogleAuth() async {
    emit(AuthLoading());
    try {
      await authServices.nativeGoogleSignIn();
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

 

  void checkAuthStatus() {
    final user = authServices.checkAuthStatus();
    if (user != null) {
      emit(AuthSuccess());
    }
  }

  Future<void> logOut() async {
    await authServices.logOut();
    emit(AuthSignOut());
  }
}
