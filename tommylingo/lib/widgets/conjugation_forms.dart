// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spoiler_widget/spoiler_text_widget.dart';
import 'package:tommylingo/json/forms.dart';

class FormsWidget extends StatelessWidget {
  final Forms forms;
  final String header;

  const FormsWidget(this.forms, this.header);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(header, style: const TextStyle(fontSize: 14)),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _spoiler(forms.yo),
          const SizedBox(height: 20),
          _spoiler(forms.tu),
          const SizedBox(height: 20),
          _spoiler(forms.el_ella_usted),
        ]),
        const SizedBox(width: 40),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _spoiler(forms.nosotros),
          const SizedBox(height: 20),
          _spoiler(forms.vosotros),
          const SizedBox(height: 20),
          _spoiler(forms.ellos_ustedes),
        ]),
      ]),
    ]);
  }

  Widget _spoiler(String text) {
    return RepaintBoundary(child: SpoilerTextWidget(
      enable: true,
      particleDensity: 15,
      speedOfParticles: 0.3,
      fadeRadius: 1,
      fadeAnimation: true,
      enableGesture: true,
      particleColor: const Color(0xFF81C784),
      text: text,
      style: const TextStyle(color: Colors.black),
    ));
  }
}
