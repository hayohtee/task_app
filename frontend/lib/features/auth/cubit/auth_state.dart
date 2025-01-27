part of "auth_cubit.dart";

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  AuthError(this.error);

  final String error;
}

final class AuthSuccess extends AuthState {}

final class AuthSignUpFailedValidation extends AuthState {
  const AuthSignUpFailedValidation({
    required this.name,
    required this.email,
    required this.password,
  });

  final String? name;
  final String? email;
  final String? password;
}
