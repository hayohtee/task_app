part of 'login_cubit.dart';

@immutable
sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {}

final class LoginError extends LoginState {
  const LoginError(this.error);

  final String error;
}

final class LoginFailedValidationError extends LoginState {
  const LoginFailedValidationError({
    required this.email,
    required this.password,
  });

  final String? email;
  final String? password;
}

final class LoginEmailNotFoundError extends LoginState {
  const LoginEmailNotFoundError(this.error);

  final String error;
}

final class LoginSuccess extends LoginState {
  const LoginSuccess({required this.tokens, required this.user});

  final TokenModel tokens;
  final UserModel user;
}
