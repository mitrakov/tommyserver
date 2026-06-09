import 'package:json_annotation/json_annotation.dart';
part 'product.g.dart';

@JsonSerializable()
class Product {
  final int? id;
  final String name;
  final String description;
  final int kcalPer100g;
  final int defaultWeight;

  Product(this.id, this.name, this.description, this.kcalPer100g, this.defaultWeight);

  @override
  String toString() =>
      'Product{id: $id, name: $name, description: $description, kcalPer100g: $kcalPer100g, defaultWeight: $defaultWeight}';
  
  Map<String, dynamic> toJson() => _$ProductToJson(this);
  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
  
  static Product empty = Product(null, "", "", 0, 0);
}
