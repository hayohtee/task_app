part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {
  const SignUpState();
}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}

final class SignUpError extends SignUpState {
  const SignUpError(this.error);

  final String error;
}

final class SignUpValidationError extends SignUpState {
  const SignUpValidationError({
    required this.name,
    required this.email,
    required this.password,
  });

  final String? name;
  final String? email;
  final String? password;
}

final class SignUpSuccess extends SignUpState {
  const SignUpSuccess({required this.tokens, required this.user});

  final TokenModel tokens;
  final UserModel user;
}
