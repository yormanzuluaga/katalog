class AuthModel {
  String? accessToken;
  String? tokenType;
  String? refreshToken;
  String? idToken;

  AuthModel({
    this.accessToken,
    this.tokenType,
    this.refreshToken,
    this.idToken,
  });

  AuthModel copyWith({
    String? accessToken,
    String? tokenType,
    String? refreshToken,
    String? idToken,
  }) =>
      AuthModel(
        accessToken: accessToken ?? this.accessToken,
        tokenType: tokenType ?? this.tokenType,
        refreshToken: refreshToken ?? this.refreshToken,
        idToken: idToken ?? this.idToken,
      );

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        accessToken: json["AccessToken"],
        tokenType: json["TokenType"],
        refreshToken: json["RefreshToken"],
        idToken: json["IdToken"],
      );

  Map<String, dynamic> toJson() => {
        "AccessToken": accessToken,
        "TokenType": tokenType,
        "RefreshToken": refreshToken,
        "IdToken": idToken,
      };
}