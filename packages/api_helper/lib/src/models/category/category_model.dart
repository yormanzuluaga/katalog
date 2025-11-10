import 'package:api_helper/api_helper.dart';

class CategoryModel {
  int? allCategory;
  List<Category>? category;

  CategoryModel({
    this.allCategory,
    this.category,
  });

  CategoryModel copyWith({
    int? allCategory,
    List<Category>? category,
  }) =>
      CategoryModel(
        allCategory: allCategory ?? this.allCategory,
        category: category ?? this.category,
      );

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        allCategory: json["allCategory"],
        category: List<Category>.from(json["category"].map((x) => Category.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "allCategory": allCategory,
        "category": List<dynamic>.from(category!.map((x) => x.toJson())),
      };
}

class Category {
  String? id;
  String? name;
  String? img;
  bool? isSubCatalogo;
  bool? estado;
  DateTime? createdAt;
  DateTime? updatedAt;

  Category({
    this.id,
    this.name,
    this.img,
    this.isSubCatalogo = false,
    this.estado,
    this.createdAt,
    this.updatedAt,
  });

  Category copyWith({
    String? id,
    String? name,
    String? img,
    bool? isSubCatalogo,
    bool? estado,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        img: img ?? this.img,
        isSubCatalogo: isSubCatalogo ?? this.isSubCatalogo,
        estado: estado ?? this.estado,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
      );

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["_id"],
        name: json["name"],
        img: json["img"],
        isSubCatalogo: json["isSubCatalogo"],
        estado: json["estado"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "img": img,
        "isSubCatalogo": isSubCatalogo,
        "estado": estado,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
