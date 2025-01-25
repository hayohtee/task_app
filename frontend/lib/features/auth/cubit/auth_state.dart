part of "auth_cubit.dart";

sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  AuthError(this.error);

  final String error;
}

final class AuthSignedIn extends AuthState {

}
