import 'package:json_annotation/json_annotation.dart';
part 'forms.g.dart';

// explicitToJson=true calls `.toJson()` for nested objects (default false)
// createFactory=false skips generation of `.fromJson()` for nested objects (default true)
@JsonSerializable(explicitToJson: true)
class Forms {
  final String yo;
  @JsonKey(name: "tú")
  final String tu;
  @JsonKey(name: "él/ella/Ud.")
  final String el_ella_usted;
  final String nosotros;
  final String vosotros;
  @JsonKey(name: "ellos/ellas/Uds.")
  final String ellos_ustedes;

  Forms(this.yo, this.tu, this.nosotros, this.vosotros, this.el_ella_usted, this.ellos_ustedes);

  factory Forms.fromJson(Map<String, dynamic> json) => _$FormsFromJson(json);
  Map<String, dynamic> toJson() => _$FormsToJson(this);

  @override
  String toString() {
    return 'Forms{yo: $yo, tu: $tu, el_ella_usted: $el_ella_usted, nosotros: $nosotros, vosotros: $vosotros, ellos_ustedes: $ellos_ustedes}';
  }
}
