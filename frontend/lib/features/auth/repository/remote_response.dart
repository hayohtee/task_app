// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

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
