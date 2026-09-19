class AuthResponseModel {
  final String accessToken;
  final DateTime expiresAtUtc;
  final String refreshToken;

  AuthResponseModel({
    required this.accessToken,
    required this.expiresAtUtc,
    required this.refreshToken,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      accessToken: json['accessToken'],
      expiresAtUtc: DateTime.parse(json['expiresAtUtc']),
      refreshToken: json['refreshToken'],
    );
  }
}
