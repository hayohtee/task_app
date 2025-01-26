part of "remote_repository.dart";

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

class UserCreated extends RemoteResponse {
  UserCreated({required this.tokens, required this.user});

  final TokenModel tokens;
  final UserModel user;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'tokens': tokens.toMap(),
      'user': user.toMap(),
    };
  }

  factory UserCreated.fromMap(Map<String, dynamic> map) {
    return UserCreated(
      tokens: TokenModel.fromMap(map['tokens'] as Map<String, dynamic>),
      user: UserModel.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserCreated.fromJson(String source) {
    return UserCreated.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
