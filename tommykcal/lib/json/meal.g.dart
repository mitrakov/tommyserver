// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Meal _$MealFromJson(Map<String, dynamic> json) => Meal(
  (json['id'] as num).toInt(),
  json['date'] as String,
  json['name'] as String,
  (json['kcalPer100g'] as num).toInt(),
  (json['weight'] as num).toInt(),
  json['comment'] as String?,
);

Map<String, dynamic> _$MealToJson(Meal instance) => <String, dynamic>{
  'id': instance.id,
  'date': instance.date,
  'name': instance.name,
  'kcalPer100g': instance.kcalPer100g,
  'weight': instance.weight,
  'comment': instance.comment,
};
