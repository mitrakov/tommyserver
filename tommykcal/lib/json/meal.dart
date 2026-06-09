import 'package:json_annotation/json_annotation.dart';
part 'meal.g.dart';

@JsonSerializable()
class Meal {
  final int id;
  final String date;
  final String name;
  final int kcalTotal;
  final String? comment;

  Meal(this.id, this.date, this.name, this.kcalTotal, this.comment);

  @override
  String toString() => 'Meal{id: $id, date: $date, name: $name, kcalTotal: $kcalTotal, comment: $comment}';

  Map<String, dynamic> toJson() => _$MealToJson(this);
  factory Meal.fromJson(Map<String, dynamic> json) => _$MealFromJson(json);
}
