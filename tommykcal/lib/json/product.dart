import 'package:json_annotation/json_annotation.dart';
part 'chronicle.g.dart';

@JsonSerializable()
class Product {
  final int? id;
  final String name;
  final String description;
  final int kcalPer100g;
  
  final Map<String, dynamic> params;
  final String? comment;

  Product(this.id, this.date, this.eventName, this.params, this.comment);

  Map<String, dynamic> toJson() => _$ChronicleToJson(this);
  factory Product.fromJson(Map<String, dynamic> json) => _$ChronicleFromJson(json);

  @override
  String toString() => 'Product{date: $date, eventName: $eventName, params: $params, comment: $comment}';
}
