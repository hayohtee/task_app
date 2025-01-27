import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/repository/remote_repository.dart';

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

      switch (response) {
        case UserCreated():
          emit(AuthSuccess());
        case Error():
          emit(AuthError(response.error));
        case SignUpFailedValidationError():
          emit(AuthSignUpFailedValidation(
            name: response.error.name,
            email: response.error.email,
            password: response.error.password,
          ));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
