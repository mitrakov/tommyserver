// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verb.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Verb _$VerbFromJson(Map<String, dynamic> json) => Verb(
      json['verbo'] as String,
      Tense.fromJson(json['perfecto'] as Map<String, dynamic>),
      Tense.fromJson(json['imperativo'] as Map<String, dynamic>),
      Tense.fromJson(json['indicativo'] as Map<String, dynamic>),
      Tense.fromJson(json['progresivo'] as Map<String, dynamic>),
      Tense.fromJson(json['subjuntivo'] as Map<String, dynamic>),
      Tense.fromJson(json['perfecto_subjuntivo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VerbToJson(Verb instance) => <String, dynamic>{
      'verbo': instance.verbo,
      'perfecto': instance.perfecto.toJson(),
      'imperativo': instance.imperativo.toJson(),
      'indicativo': instance.indicativo.toJson(),
      'progresivo': instance.progresivo.toJson(),
      'subjuntivo': instance.subjuntivo.toJson(),
      'perfecto_subjuntivo': instance.perfecto_subjuntivo.toJson(),
    };
