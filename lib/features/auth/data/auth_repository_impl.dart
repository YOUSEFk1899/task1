import '../domain/auth_repository.dart';
import 'auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> login({required String email, required String password}) async {
    await remoteDataSource.login(email: email, password: password);
  }

  @override
  Future<void> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    await remoteDataSource.register(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }

  @override
  Future<void> verifyEmail({required String email, required String otp}) async {
    await remoteDataSource.verifyEmail(email: email, otp: otp);
  }
}
