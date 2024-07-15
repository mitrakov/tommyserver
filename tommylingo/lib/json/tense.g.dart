// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tense _$TenseFromJson(Map<String, dynamic> json) => Tense(
      Forms.fromJson(json['futuro'] as Map<String, dynamic>),
      Forms.fromJson(json['pasado'] as Map<String, dynamic>),
      Forms.fromJson(json['presente'] as Map<String, dynamic>),
      Forms.fromJson(json['preterito'] as Map<String, dynamic>),
      Forms.fromJson(json['condicional'] as Map<String, dynamic>),
      Forms.fromJson(json['afirmativo'] as Map<String, dynamic>),
      Forms.fromJson(json['negativo'] as Map<String, dynamic>),
      Forms.fromJson(json['imperfecto'] as Map<String, dynamic>),
      Forms.fromJson(json['imperfecto2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TenseToJson(Tense instance) => <String, dynamic>{
      'futuro': instance.futuro.toJson(),
      'pasado': instance.pasado.toJson(),
      'presente': instance.presente.toJson(),
      'preterito': instance.preterito.toJson(),
      'condicional': instance.condicional.toJson(),
      'afirmativo': instance.afirmativo.toJson(),
      'negativo': instance.negativo.toJson(),
      'imperfecto': instance.imperfecto.toJson(),
      'imperfecto2': instance.imperfecto2.toJson(),
    };
