class SubCategoryModel {
  int? total;
  List<SubCategory>? subCategories;

  SubCategoryModel({
    this.total,
    this.subCategories,
  });

  SubCategoryModel copyWith({
    int? total,
    List<SubCategory>? subCategories,
  }) =>
      SubCategoryModel(
        total: total ?? this.total,
        subCategories: subCategories ?? this.subCategories,
      );

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) => SubCategoryModel(
        total: json["total"],
        subCategories: List<SubCategory>.from(json["subCategories"].map((x) => SubCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "subCategories": List<dynamic>.from(subCategories!.map((x) => x.toJson())),
      };
}

class SubCategory {
  String? id;
  String? name;
  String? description;
  Categorys? category;
  String? img;
  bool? estado;
  Users? user;
  DateTime? createdAt;
  DateTime? updatedAt;

  SubCategory({
    this.id,
    this.name,
    this.description,
    this.category,
    this.img,
    this.estado,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  SubCategory copyWith({
    String? id,
    String? name,
    String? description,
    Categorys? category,
    String? img,
    bool? estado,
    Users? user,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      SubCategory(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        category: category ?? this.category,
        img: img ?? this.img,
        estado: estado ?? this.estado,
        user: user ?? this.user,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        category: Categorys.fromJson(json["category"]),
        img: json["img"],
        estado: json["estado"],
        user: Users.fromJson(json["user"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "category": category?.toJson(),
        "img": img,
        "estado": estado,
        "user": user?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class Categorys {
  String? id;
  String? name;

  Categorys({
    this.id,
    this.name,
  });

  Categorys copyWith({
    String? id,
    String? name,
  }) =>
      Categorys(
        id: id ?? this.id,
        name: name ?? this.name,
      );

  factory Categorys.fromJson(Map<String, dynamic> json) => Categorys(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}

class Users {
  String? id;
  String? firstName;

  Users({
    this.id,
    this.firstName,
  });

  Users copyWith({
    String? id,
    String? firstName,
  }) =>
      Users(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
      );

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["_id"],
        firstName: json["firstName"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
      };
}
