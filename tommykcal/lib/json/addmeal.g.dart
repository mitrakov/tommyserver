// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'addmeal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddMeal _$AddMealFromJson(Map<String, dynamic> json) => AddMeal(
  json['date'] as String,
  (json['productId'] as num).toInt(),
  (json['weight'] as num).toInt(),
  json['comment'] as String?,
);

Map<String, dynamic> _$AddMealToJson(AddMeal instance) => <String, dynamic>{
  'date': instance.date,
  'productId': instance.productId,
  'weight': instance.weight,
  'comment': instance.comment,
};
