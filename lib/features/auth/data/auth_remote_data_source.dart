import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';

class AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSource(this.dio);

  Future<Response> login({
    required String email,
    required String password,
  }) async {
    return await dio.post(
      ApiConstants.login,
      data: {'email': email, 'password': password},
    );
  }

  Future<Response> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    return await dio.post(
      ApiConstants.register,
      data: {
        'email': email,
        'password': password,
        'firstName': firstName,
        'lastName': lastName,
      },
    );
  }

  Future<Response> verifyEmail({
    required String email,
    required String otp,
  }) async {
    return await dio.post(
      ApiConstants.verifyEmail,
      data: {'email': email, 'otp': otp},
    );
  }
}
