import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:frontend/core/constants/constants.dart';
import 'package:frontend/models/token_model.dart';
import 'package:frontend/models/user_model.dart';

part 'remote_response.dart';
part 'remote_request.dart';

class RemoteRepository {
  Future<RemoteResponse> signUp({
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

      switch (response.statusCode) {
        case 201:
          return UserCreated.fromJson(response.body);
        case 422:
          return SignUpFailedValidationError.fromJson(response.body);
        default:
          return Error.fromJson(response.body);
      }
    } catch (e) {
      debugPrint(e.toString());
      throw e.toString();
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {}
}
