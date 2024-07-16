// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Forms _$FormsFromJson(Map<String, dynamic> json) => Forms(
      json['yo'] as String,
      json['tú'] as String,
      json['nosotros'] as String,
      json['vosotros'] as String,
      Forms.readEl(json, 'el_ella_usted') as String,
      Forms.readEllos(json, 'ellos_ustedes') as String,
    );

Map<String, dynamic> _$FormsToJson(Forms instance) => <String, dynamic>{
      'yo': instance.yo,
      'tú': instance.tu,
      'el_ella_usted': instance.el_ella_usted,
      'nosotros': instance.nosotros,
      'vosotros': instance.vosotros,
      'ellos_ustedes': instance.ellos_ustedes,
    };
