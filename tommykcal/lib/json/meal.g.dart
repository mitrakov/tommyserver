// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
  (json['id'] as num).toInt(),
  json['date'] as String,
  json['name'] as String,
  (json['kcalTotal'] as num).toInt(),
  json['comment'] as String?,
);

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'name': instance.name,
  'kcalTotal': instance.kcalTotal,
  'comment': instance.comment,
};
