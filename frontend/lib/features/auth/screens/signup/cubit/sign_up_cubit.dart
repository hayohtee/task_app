import 'package:bloc/bloc.dart';
import 'package:frontend/models/token_model.dart';
import 'package:frontend/models/user_model.dart';
import 'package:meta/meta.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  SignUpCubit() : super(SignUpInitial());
}
