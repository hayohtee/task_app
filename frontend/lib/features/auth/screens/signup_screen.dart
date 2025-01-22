import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
                decoration: InputDecoration(hintText: "Name"),
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
                decoration: InputDecoration(hintText: "Email"),
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
                decoration: InputDecoration(hintText: "Password"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Password field cannot be empty";
                  }

                  if (value.trim().length < 6) {
                    return "Password field should be at least 7 characters long";
                  }

                  return null;
                },
              ),
              SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {},
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
  }

  void signUpUser() {
    if (_formKey.currentState!.validate()) {
      
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
