import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repository/remote_repository.dart';
import 'package:frontend/models/token_model.dart';
import 'package:frontend/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final remoteRepository = RemoteRepository();

  void signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());
      final response = await remoteRepository.signUp(
        email: email,
        password: password,
        name: name,
      );

      if (response is Success) {
        emit(AuthSuccess(tokens: response.tokens, user: response.user));
        return;
      }

      if (response is SignUpFailedValidationError) {
        emit(AuthSignUpFailedValidation(
          name: response.name,
          email: response.email,
          password: response.password,
        ));
        return;
      }

      if (response is Error) {
        emit(AuthError(response.error));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void login(String email, String password) async {
    try {
      emit(AuthLoading());
      final response = await remoteRepository.login(email: email, password: password);

      if (response is Success) {
        emit(AuthSuccess(user: response.user, tokens: response.tokens));
        return;
      }

      if (response is LoginFailedValidationError) {
        emit(AuthLoginFailedValidation(
          email: response.email,
          password: response.password,
        ));
        return;
      }

      if (response is EmailNotFound) {
        emit(AuthEmailNotFound(response.message));
        return;
      }

      if (response is InvalidCredentials) {
        emit(AuthInvalidCredentials(response.message));
        return;
      }

      if (response is Error) {
        emit(AuthError(response.error));
      }
    } catch (e) {
      debugPrint("Auth cubit ${e.toString()}");
      emit(AuthError(e.toString()));
    }
  }
}
