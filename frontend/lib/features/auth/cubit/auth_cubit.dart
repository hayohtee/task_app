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
    emit(AuthLoading());
    final response = await remoteRepository.login(email: email, password: password);
    switch (response) {
      case Success():
        emit(AuthSuccess(user: response.user, tokens: response.tokens));
        break;
      case SignUpFailedValidationError():
        emit(AuthSignUpFailedValidation(
          name: response.name,
          email: response.email,
          password: response.password,
        ));
        break;
      case Error():
        emit(AuthError(response.error));
        break;
    }
  }

  void login(String email, String password) async {
    emit(AuthLoading());

    final response = await remoteRepository.login(email: email, password: password);

    switch (response) {
      case Success():
        emit(AuthSuccess(user: response.user, tokens: response.tokens));
        break;
      case EmailNotFound():
        emit(AuthEmailNotFound(response.message));
        break;
      case InvalidCredentials():
        emit(AuthInvalidCredentials(response.message));
        break;
      case Error():
        emit(AuthError(response.error));
        break;
    }
  }
}
