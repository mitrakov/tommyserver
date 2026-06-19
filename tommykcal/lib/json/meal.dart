import 'package:json_annotation/json_annotation.dart';
part 'meal.g.dart';

@JsonSerializable()
class Meal {
  final int id;
  final String date;
  final String name;
  final int kcalPer100g;
  final int weight;
  final String? comment;

  Meal(this.id, this.date, this.name, this.kcalPer100g, this.weight, this.comment);

  @override
  String toString() => 'Meal{id: $id, date: $date, name: $name, kcalPer100g: $kcalPer100g, weight: $weight, comment: $comment}';

  Map<String, dynamic> toJson() => _$MealToJson(this);
  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
