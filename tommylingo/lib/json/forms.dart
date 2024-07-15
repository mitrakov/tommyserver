import 'package:json_annotation/json_annotation.dart';
part 'forms.g.dart';

// explicitToJson=true calls `.toJson()` for nested objects (default false)
// createFactory=false skips generation of `.fromJson()` for nested objects (default true)
@JsonSerializable(explicitToJson: true)
class Forms {
  final String yo;
  final String tu;
  final String nosotros;
  final String vosotros;
  final String el_ella_usted;
  final String ellos;

  Forms(this.yo, this.tu, this.nosotros, this.vosotros, this.el_ella_usted, this.ellos);

  //Person(this.id, this.names); // use either public fields, or constructor args, or private fields with getter/setter

  factory Forms.fromJson(Map<String, dynamic> json) => _$FormsFromJson(json);
  Map<String, dynamic> toJson() => _$FormsToJson(this);
}
