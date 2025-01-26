// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:frontend/models/token_model.dart';
import 'package:frontend/models/user_model.dart';

sealed class RemoteResponse {}

class FailedValidationError extends RemoteResponse {
  FailedValidationError({
    required this.email,
    required this.name,
    required this.password,
  });

  final String name;
  final String email;
  final String password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory FailedValidationError.fromMap(Map<String, dynamic> map) {
    return FailedValidationError(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory FailedValidationError.fromJson(String source) {
    return FailedValidationError.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}

class CreatedResponse extends RemoteResponse {
  CreatedResponse({required this.tokens, required this.user});

  final TokenModel tokens;
  final UserModel user;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokens': tokens.toMap(),
      'user': user.toMap(),
    };
  }

  factory CreatedResponse.fromMap(Map<String, dynamic> map) {
    return CreatedResponse(
      tokens: TokenModel.fromMap(map['tokens'] as Map<String, dynamic>),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory CreatedResponse.fromJson(String source) {
    return CreatedResponse.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
