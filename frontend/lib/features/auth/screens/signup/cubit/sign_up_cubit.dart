import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repository/remote_repository.dart';
import 'package:frontend/models/token_model.dart';
import 'package:frontend/models/user_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());

  final repository = RemoteRepository();

  void signUp(String name, String email, String password) async {
    emit(SignUpLoading());

    final response = await repository.signUp(
      name: name,
      email: email,
      password: password,
    );

    switch (response) {
      case Success():
        emit(SignUpSuccess(tokens: response.tokens, user: response.user));
        break;
      case SignUpFailedValidationError():
        emit(SignUpValidationError(
          name: response.name,
          email: response.email,
          password: response.password,
        ));
        break;
      case Error():
        emit(SignUpError(response.error));
        break;
    }
  }
}
