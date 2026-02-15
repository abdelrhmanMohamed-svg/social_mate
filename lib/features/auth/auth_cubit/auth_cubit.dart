import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mate/core/models/notification_model.dart';
import 'package:social_mate/core/services/fcm_services.dart';
import 'package:social_mate/features/auth/services/auth_services.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final authServices = AuthServicesImpl();
  final _fcmServices = FcmServicesImpl();

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
    emit(AuthSignOutLoading());
    try {
      await authServices.signOut();
      await _fcmServices.dispose();
      emit(AuthSignOutSuccess());
    } catch (e) {
      emit(AuthSignOutFailure(e.toString()));
    }
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

  void checkAuthStatus() async {
    final user = authServices.checkAuthStatus();
    if (user != null) {
      emit(AuthSuccess());
      _handleFCMToken(user.id);
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _handleFCMToken(String userId) async {
    final fcmToken = await _fcmServices.getFcmToken();

    if (fcmToken == null) {
      return;
    }

    final oldToken = await _fcmServices.getSavedFcmToken(userId);

    if (oldToken != fcmToken) {
      final saved = await _fcmServices.saveFcmTokenToDatabase(fcmToken);
      if (saved) {
        debugPrint('✅ FCM token updated successfully');
      }
    } else {
      debugPrint('📱 FCM token unchanged');
    }
    _fcmServices.startListeningForTokenChanges();
  }
}
