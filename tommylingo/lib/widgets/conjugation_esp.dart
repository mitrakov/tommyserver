import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tommylingo/json/verb.dart';
import 'package:tommylingo/widgets/conjugation_forms.dart';

class ConjugationsEsp extends StatelessWidget {
  final Verb verb;

  const ConjugationsEsp(this.verb);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(verb.verbo, style: const TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(children: [
        FormsWidget(verb.indicativo.presente!,    "Presente"),
        FormsWidget(verb.perfecto.presente!,      "Pretérito Perfecto"),
        FormsWidget(verb.indicativo.preterito!,   "Pretérito Simple"),
        FormsWidget(verb.indicativo.imperfecto!,  "Imperfecto"),
        FormsWidget(verb.indicativo.futuro!,      "Futuro"),
        FormsWidget(verb.indicativo.condicional!, "Condicional"),
      ]),
    );
  }
}
