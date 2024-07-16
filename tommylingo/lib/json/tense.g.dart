// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Tense _$TenseFromJson(Map<String, dynamic> json) => Tense(
      json['futuro'] == null
          ? null
          : Forms.fromJson(json['futuro'] as Map<String, dynamic>),
      json['pasado'] == null
          ? null
          : Forms.fromJson(json['pasado'] as Map<String, dynamic>),
      json['presente'] == null
          ? null
          : Forms.fromJson(json['presente'] as Map<String, dynamic>),
      json['preterito'] == null
          ? null
          : Forms.fromJson(json['preterito'] as Map<String, dynamic>),
      json['condicional'] == null
          ? null
          : Forms.fromJson(json['condicional'] as Map<String, dynamic>),
      json['afirmativo'] == null
          ? null
          : FormsImperative.fromJson(
              json['afirmativo'] as Map<String, dynamic>),
      json['negativo'] == null
          ? null
          : FormsImperative.fromJson(json['negativo'] as Map<String, dynamic>),
      json['imperfecto'] == null
          ? null
          : Forms.fromJson(json['imperfecto'] as Map<String, dynamic>),
      json['imperfecto2'] == null
          ? null
          : Forms.fromJson(json['imperfecto2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TenseToJson(Tense instance) => <String, dynamic>{
      'futuro': instance.futuro?.toJson(),
      'pasado': instance.pasado?.toJson(),
      'presente': instance.presente?.toJson(),
      'preterito': instance.preterito?.toJson(),
      'condicional': instance.condicional?.toJson(),
      'imperfecto': instance.imperfecto?.toJson(),
      'imperfecto2': instance.imperfecto2?.toJson(),
      'afirmativo': instance.afirmativo?.toJson(),
      'negativo': instance.negativo?.toJson(),
    };
