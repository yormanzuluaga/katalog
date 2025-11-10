class UserModel {
  User? user;
  String? token;

  UserModel({
    this.user,
    this.token,
  });

  UserModel copyWith({
    User? user,
    String? token,
  }) =>
      UserModel(
        user: user ?? this.user,
        token: token ?? this.token,
      );

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "user": user?.toJson(),
        "token": token,
      };
}

class User {
  String? firstName;
  String? lastName;
  String? email;
  String? countryCode;
  String? mobile;
  String? avatar;
  String? rol;
  bool? estado;
  bool? google;
  bool? apple;
  bool? facebook;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? uid;

  User({
    this.firstName,
    this.lastName,
    this.email,
    this.countryCode,
    this.mobile,
    this.avatar,
    this.rol,
    this.estado,
    this.google,
    this.apple,
    this.facebook,
    this.createdAt,
    this.updatedAt,
    this.uid,
  });

  User copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? countryCode,
    String? mobile,
    String? avatar,
    String? rol,
    bool? estado,
    bool? google,
    bool? apple,
    bool? facebook,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? uid,
  }) =>
      User(
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        countryCode: countryCode ?? this.countryCode,
        mobile: mobile ?? this.mobile,
        avatar: avatar ?? this.avatar,
        rol: rol ?? this.rol,
        estado: estado ?? this.estado,
        google: google ?? this.google,
        apple: apple ?? this.apple,
        facebook: facebook ?? this.facebook,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        uid: uid ?? this.uid,
      );

  factory User.fromJson(Map<String, dynamic> json) => User(
        firstName: json["firstName"],
        lastName: json["lastName"],
        email: json["email"],
        countryCode: json["countryCode"],
        mobile: json["mobile"],
        avatar: json["avatar"],
        rol: json["rol"],
        estado: json["estado"],
        google: json["google"],
        apple: json["apple"],
        facebook: json["facebook"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        uid: json["uid"],
      );

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "countryCode": countryCode,
        "mobile": mobile,
        "avatar": avatar,
        "rol": rol,
        "estado": estado,
        "google": google,
        "apple": apple,
        "facebook": facebook,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "uid": uid,
      };
}
