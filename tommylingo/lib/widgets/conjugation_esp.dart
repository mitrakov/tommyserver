// ignore_for_file: use_key_in_widget_constructors

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
        FormsWidget(verb.indicativo.presente!,    "Presente indicativo"),
        FormsWidget(verb.perfecto.presente!,      "Presente perfecto"),
        FormsWidget(verb.indicativo.preterito!,   "Preterito indicativo"),
        FormsWidget(verb.indicativo.imperfecto!,  "Imperfecto indicativo"),
        FormsWidget(verb.indicativo.futuro!,      "Futuro indicativo"),
        FormsWidget(verb.indicativo.condicional!, "Condicional indicativo"),
      ]),
    );
  }
}
