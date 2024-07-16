import 'package:json_annotation/json_annotation.dart';
part 'forms_imperative.g.dart';

// explicitToJson=true calls `.toJson()` for nested objects (default false)
// createFactory=false skips generation of `.fromJson()` for nested objects (default true)
@JsonSerializable(explicitToJson: true)
class FormsImperative {
  final String yo;
  @JsonKey(name: "tú")
  final String tu;
  @JsonKey(name: "Ud.")
  final String usted;
  final String nosotros;
  final String vosotros;
  @JsonKey(name: "Uds.")
  final String ustedes;

  FormsImperative(this.yo, this.tu, this.usted, this.nosotros, this.vosotros, this.ustedes);

  factory FormsImperative.fromJson(Map<String, dynamic> json) => _$FormsImperativeFromJson(json);

  Map<String, dynamic> toJson() => _$FormsImperativeToJson(this);

  @override
  String toString() {
    return 'FormsImperative{yo: $yo, tu: $tu, usted: $usted, nosotros: $nosotros, vosotros: $vosotros, ustedes: $ustedes}';
  }
}
