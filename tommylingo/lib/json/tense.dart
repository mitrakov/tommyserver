import 'package:json_annotation/json_annotation.dart';
import 'package:tommylingo/json/forms.dart';
part 'tense.g.dart';

// explicitToJson=true calls `.toJson()` for nested objects (default false)
@JsonSerializable(explicitToJson: true)
class Tense {
  final Forms? futuro;      // for perfecto, indicativo, progresivo, subjuntivo, perfecto_subjuntivo
  final Forms? pasado;      // for perfecto, perfecto_subjuntivo
  final Forms? presente;    // for perfecto, indicativo, progresivo, subjuntivo, perfecto_subjuntivo
  final Forms? preterito;   // for perfecto, indicativo, progresivo
  final Forms? condicional; // for perfecto, indicativo, progresivo
  final Forms? imperfecto;  // for indicativo, progresivo, subjuntivo
  final Forms? imperfecto2; // for subjuntivo only
  final Forms? afirmativo;  // for imperativo only
  final Forms? negativo;    // for imperativo only

  Tense(this.futuro, this.pasado, this.presente, this.preterito, this.condicional, this.afirmativo, this.negativo, this.imperfecto, this.imperfecto2);

  factory Tense.fromJson(Map<String, dynamic> json) => _$TenseFromJson(json);
  Map<String, dynamic> toJson() => _$TenseToJson(this);

  @override
  String toString() {
    return 'Tense{futuro: $futuro, pasado: $pasado, presente: $presente, preterito: $preterito, condicional: $condicional, imperfecto: $imperfecto, imperfecto2: $imperfecto2, afirmativo: $afirmativo, negativo: $negativo}';
  }
}
