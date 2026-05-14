class AuthUser {
  final String id;
  final String? email;
  final String? phoneNumber;

  const AuthUser({
    required this.id,
    this.email,
    this.phoneNumber,
  });
}
