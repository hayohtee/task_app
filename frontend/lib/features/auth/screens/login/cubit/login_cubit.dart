import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repository/remote_repository.dart';
import 'package:frontend/models/user_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final repository = RemoteRepository();

  void login(String email, String password) async {
    emit(LoginLoading());

    final response = await repository.login(email: email, password: password);
    switch (response) {
      case Success():
        emit(LoginSuccess(response.user));
        break;
      case LoginFailedValidationError():
        emit(LoginValidationError(
          email: response.email,
          password: response.password,
        ));
        break;
      case EmailNotFound():
        emit(LoginEmailNotFoundError(response.message));
        break;
      case InvalidCredentials():
        emit(LoginInvalidCredentialsError(response.message));
        break;
      case Error():
        emit(LoginError(response.error));
        break;
    }
  }
}
