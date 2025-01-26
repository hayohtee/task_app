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
}
