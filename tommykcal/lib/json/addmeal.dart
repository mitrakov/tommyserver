import 'package:json_annotation/json_annotation.dart';
part 'addmeal.g.dart';

@JsonSerializable()
class AddMeal {
  final String date;
  final int productId;
  final int weight;
  final String? comment;

  AddMeal(this.date, this.productId, this.weight, this.comment);

  @override
  String toString() => 'AddMeal{date: $date, productId: $productId, weight: $weight, comment: $comment}';

  Map<String, dynamic> toJson() => _$AddMealToJson(this);
  factory AddMeal.fromJson(Map<String, dynamic> json) => _$AddMealFromJson(json);
}
