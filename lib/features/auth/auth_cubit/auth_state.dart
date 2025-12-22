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
final class AuthSignOut extends AuthState {}

