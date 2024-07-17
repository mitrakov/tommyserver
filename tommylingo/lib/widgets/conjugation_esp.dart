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
      appBar: AppBar(title: Text(verb.verbo)),
      body: Center(
        child: Column(children: [
          Expanded(
            child: ListView(children: [
              FormsWidget(verb.indicativo.presente!, "Presente indicativo"),
              FormsWidget(verb.perfecto.presente!, "Presente perfecto"),
            ]),
          ),
        ]),
      ),
    );
  }
}
