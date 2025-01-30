import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/screens/signup_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'cubit/login_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _emailError;
  String? _passwordError;
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<LoginCubit, LoginState>(
            listener: (context, state) {
              switch (state) {
                case LoginValidationError():
                  setState(() {
                    _emailError = state.email;
                    _passwordError = state.password;
                  });
                  break;
                case LoginSuccess():
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${state.user.name} logged in successfully"),
                    ),
                  );
                  break;
                case LoginEmailNotFoundError():
                  setState(() {
                    _emailError = state.error;
                  });
                  break;
                case LoginInvalidCredentialsError():
                  setState(() {
                    _emailError = "";
                    _passwordError = state.error;
                  });
                  break;

                case LoginError():
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.error),
                    ),
                  );
                  break;
                default:
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Login.",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 32),
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Email",
                            errorText: _emailError,
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final regex = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

                            if (value == null) {
                              return "Email field cannot be empty";
                            }

                            if (!regex.hasMatch(value.trim())) {
                              return "Email field contains an invalid email address";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            errorText: _passwordError,
                            errorMaxLines: 2,
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obscureText = !_obscureText;
                                });
                              },
                              icon: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ),
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Password field cannot be empty";
                            }

                            if (value.trim().length < 7) {
                              return "Password field should be at least 7 characters long";
                            }

                            return null;
                          },
                        ),
                        SizedBox(height: 32),
                        (state is AuthLoading)
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  height: 60,
                                  width: double.maxFinite,
                                  child: LoadingIndicator(
                                    indicatorType: Indicator.ballPulse,
                                    colors: [Colors.white],
                                    strokeWidth: 2,
                                    backgroundColor: Colors.black,
                                    pathBackgroundColor: Colors.black,
                                  ),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: loginUser,
                                child: Text(
                                  "LOGIN",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                        SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: "Don't have an account? ",
                            style: TextTheme.of(context).titleMedium,
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SignUpScreen(),
                                      ),
                                    );
                                  },
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void loginUser() {
    if (_formKey.currentState!.validate()) {
      context.read<LoginCubit>().login(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
