import 'package:json_annotation/json_annotation.dart';
import 'package:tommylingo/json/tense.dart';
part 'verb.g.dart';

// explicitToJson=true calls `.toJson()` for nested objects (default false)
@JsonSerializable(explicitToJson: true)
class Verb {
  final String verbo;
  final Tense perfecto;
  final Tense imperativo;
  final Tense indicativo;
  final Tense progresivo;
  final Tense subjuntivo;
  final Tense perfecto_subjuntivo;

  Verb(this.verbo, this.perfecto, this.imperativo, this.indicativo, this.progresivo, this.subjuntivo, this.perfecto_subjuntivo);

  factory Verb.fromJson(Map<String, dynamic> json) => _$VerbFromJson(json);
  Map<String, dynamic> toJson() => _$VerbToJson(this);

  @override
  String toString() {
    return 'Verb{verbo: $verbo, perfecto: $perfecto, imperativo: $imperativo, indicativo: $indicativo, progresivo: $progresivo, subjuntivo: $subjuntivo, perfecto_subjuntivo: $perfecto_subjuntivo}';
  }
}
