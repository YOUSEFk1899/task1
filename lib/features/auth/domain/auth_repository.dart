abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  });

  Future<void> verifyEmail({required String email, required String otp});
}
