part of 'remote_repository.dart';

class SignUpRequest {
  SignUpRequest({
    required this.name,
    required this.email,
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

  factory SignUpRequest.fromMap(Map<String, dynamic> map) {
    return SignUpRequest(
      name: map['name'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpRequest.fromJson(String source) {
    return SignUpRequest.fromMap(json.decode(source) as Map<String, dynamic>);
  }
}
