part of "auth_cubit.dart";

sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthError extends AuthState {
  const AuthError(this.error);

  final String error;
}

final class AuthSuccess extends AuthState {
  const AuthSuccess({required this.user, required this.tokens});

  final TokenModel tokens;
  final UserModel user;
}

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

final class AuthLoginFailedValidation extends AuthState {
  const AuthLoginFailedValidation({
    required this.email,
    required this.password,
  });

  final String? email;
  final String? password;
}
