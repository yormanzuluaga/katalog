class ProductCartModel {
  ProductCartModel({
    this.id,
    this.price,
    this.productImage,
    this.quantity,
    this.note,
    this.total,
    this.type,
    this.product,
    this.barcode,
    this.brand,
    this.model,
    this.description,
  });

  String? id;
  String? note;
  int? price;
  String? productImage;
  int? quantity;
  String? total;
  bool? product;
  String? barcode;
  String? type;
  String? brand;
  String? model;
  String? description;

  ProductCartModel copyWith({
    String? id,
    String? note,
    int? price,
    String? productImage,
    int? quantity,
    String? total,
    bool? product,
    String? barcode,
    String? type,
    String? brand,
    String? model,
    String? description,
  }) =>
      ProductCartModel(
        id: id ?? this.id,
        note: note ?? this.note,
        price: price ?? this.price,
        productImage: productImage ?? this.productImage,
        quantity: quantity ?? this.quantity,
        total: total ?? this.total,
        product: product ?? this.product,
        barcode: barcode ?? this.barcode,
        type: type ?? this.type,
        brand: brand ?? this.brand,
        model: model ?? this.model,
        description: description ?? this.description,
      );

  factory ProductCartModel.fromJson(Map<String, dynamic> json) =>
      ProductCartModel(
        id: json["id"],
        note: json["note"],
        price: (json["price"]),
        productImage: json["productImage"],
        quantity: json["quantity"],
        total: json["total"],
        product: json["product"],
        barcode: json["barcode"],
        type: json["type"],
        brand: json["brand"],
        model: json["model"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "note": note,
        "price": price,
        "productImage": productImage,
        "quantity": quantity,
        "total": total,
        "product": product,
        "barcode": barcode,
        "type": type,
        "brand": brand,
        "model": model,
        "description": description,
      };
}
