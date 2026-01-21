part of 'auth_cubit.dart';


sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {}

final class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);
}
// Sign Out states
final class AuthSignOutLoading extends AuthState {}

final class AuthSignOutSuccess extends AuthState {}

final class AuthSignOutFailure extends AuthState {
  final String message;

  const AuthSignOutFailure(this.message);
}

