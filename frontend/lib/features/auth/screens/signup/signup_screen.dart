import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/cubit/auth_cubit.dart';
import 'package:frontend/features/auth/screens/login/login_screen.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'cubit/sign_up_cubit.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  String? _emailError;
  String? _passwordError;
  String? _nameError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<SignUpCubit, SignUpState>(
            listener: (context, state) {
              switch (state) {
                case SignUpSuccess():
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Account created! Login Now!"),
                    ),
                  );
                  break;
                case SignUpValidationError():
                  setState(() {
                    _emailError = state.email;
                    _passwordError = state.password;
                    _nameError = state.name;
                  });
                  break;
                case SignUpError():
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
                          "Sign Up.",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 32),
                        TextFormField(
                          controller: _nameController,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            hintText: "Name",
                            errorText: _nameError,
                          ),
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Name field cannot be empty";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 16),
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
                          decoration: InputDecoration(
                            hintText: "Password",
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
                            errorText: _passwordError,
                          ),
                          textInputAction: TextInputAction.done,
                          obscureText: _obscureText,
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
                                onPressed: signUpUser,
                                child: Text(
                                  "SIGN UP",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                        SizedBox(height: 16),
                        RichText(
                          text: TextSpan(
                            text: "Already have an account? ",
                            style: TextTheme.of(context).titleMedium,
                            children: [
                              TextSpan(
                                text: "Sign In",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
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

  void signUpUser() {
    if (_formKey.currentState!.validate()) {
      context.read<SignUpCubit>().signUp(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}
