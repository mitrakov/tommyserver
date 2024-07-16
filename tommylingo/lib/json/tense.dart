import 'package:json_annotation/json_annotation.dart';
import 'package:tommylingo/json/forms.dart';
part 'tense.g.dart';

// explicitToJson=true calls `.toJson()` for nested objects (default false)
// createFactory=false skips generation of `.fromJson()` for nested objects (default true)
@JsonSerializable(explicitToJson: true)
class Tense {
  final Forms? futuro;
  final Forms? pasado;
  final Forms? presente;
  final Forms? preterito;
  final Forms? condicional;
  final Forms? imperfecto;
  final Forms? imperfecto2;
  final Forms? afirmativo;
  final Forms? negativo;

  Tense(this.futuro, this.pasado, this.presente, this.preterito, this.condicional, this.afirmativo, this.negativo, this.imperfecto, this.imperfecto2);

  factory Tense.fromJson(Map<String, dynamic> json) => _$TenseFromJson(json);
  Map<String, dynamic> toJson() => _$TenseToJson(this);

  @override
  String toString() {
    return 'Tense{futuro: $futuro, pasado: $pasado, presente: $presente, preterito: $preterito, condicional: $condicional, imperfecto: $imperfecto, imperfecto2: $imperfecto2, afirmativo: $afirmativo, negativo: $negativo}';
  }
}
