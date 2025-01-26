// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/token_model.dart';
import 'package:frontend/models/user_model.dart';

class RemoteRepository {
  Future<AuthResponse> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("${Constants.apiURI}/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode != 201) {
        throw jsonDecode(response.body)["error"];
      }
      return AuthResponse.fromJson(response.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {}
}
