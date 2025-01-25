// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/token_model.dart';
import 'package:frontend/models/user_model.dart';

class RemoteRepository {
  Future<AuthResponse> login({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${Constants.apiURI}/auth/register"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode != 201) {
        throw jsonDecode(response.body)["error"];
      }
      return AuthResponse.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {}
}

class AuthResponse {
  AuthResponse({
    required this.tokens,
    required this.user,
  });

  final TokenModel tokens;
  final UserModel user;

  AuthResponse copyWith({
    TokenModel? tokens,
    UserModel? user,
  }) {
    return AuthResponse(
      tokens: tokens ?? this.tokens,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokens': tokens.toMap(),
      'user': user.toMap(),
    };
  }

  factory AuthResponse.fromMap(Map<String, dynamic> map) {
    return AuthResponse(
      tokens: TokenModel.fromMap(map['tokens'] as Map<String, dynamic>),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthResponse.fromJson(String source) {
    return AuthResponse.fromMap(json.decode(source) as Map<String, dynamic>);
  }

  @override
  String toString() => 'AuthResponse(tokens: $tokens, user: $user)';

  @override
  bool operator ==(covariant AuthResponse other) {
    if (identical(this, other)) return true;

    return other.tokens == tokens && other.user == user;
  }

  @override
  int get hashCode => tokens.hashCode ^ user.hashCode;
}
