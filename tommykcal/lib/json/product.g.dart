// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  (json['id'] as num?)?.toInt(),
  json['name'] as String,
  json['description'] as String?,
  (json['kcalPer100g'] as num).toInt(),
  (json['defaultWeight'] as num).toInt(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'kcalPer100g': instance.kcalPer100g,
  'defaultWeight': instance.defaultWeight,
};
