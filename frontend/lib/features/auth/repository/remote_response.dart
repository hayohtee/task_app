part of "remote_repository.dart";

sealed class RemoteResponse {
  const RemoteResponse();
}

class SignUpFailedValidationError extends RemoteResponse {
  const SignUpFailedValidationError({
    required this.email,
    required this.name,
    required this.password,
  });

  final String? name;
  final String? email;
  final String? password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory SignUpFailedValidationError.fromMap(Map<String, dynamic> map) {
    return SignUpFailedValidationError(
      name: map['error']['name'] != null ? map['error']['name'] as String : null,
      email: map['error']['email'] != null ? map['error']['email'] as String : null,
      password: map['error']['password'] != null ? map['error']['password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpFailedValidationError.fromJson(String source) {
    return SignUpFailedValidationError.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}

class LoginFailedValidationError extends RemoteResponse {
  const LoginFailedValidationError({
    required this.email,
    required this.password,
  });

  final String? email;
  final String? password;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'password': password,
    };
  }

  factory LoginFailedValidationError.fromMap(Map<String, dynamic> map) {
    return LoginFailedValidationError(
      email: map['error']['email'] != null ? map['error']['email'] as String : null,
      password: map['error']['password'] != null ? map['error']['password'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginFailedValidationError.fromJson(String source) {
    return LoginFailedValidationError.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}

class Success extends RemoteResponse {
  Success({required this.tokens, required this.user});

  final TokenModel tokens;
  final UserModel user;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokens': tokens.toMap(),
      'user': user.toMap(),
    };
  }

  factory Success.fromMap(Map<String, dynamic> map) {
    return Success(
      tokens: TokenModel.fromMap(map['tokens'] as Map<String, dynamic>),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Success.fromJson(String source) {
    return Success.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}

class Error extends RemoteResponse {
  Error({required this.error});

  final String error;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'error': error,
    };
  }

  factory Error.fromMap(Map<String, dynamic> map) {
    return Error(
      error: map['error'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Error.fromJson(String source) {
    return Error.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
