import 'package:flutter/material.dart';
import 'package:spoiler_widget/spoiler_text_widget.dart';
import 'package:tommylingo/json/forms.dart';

class FormsWidget extends StatelessWidget {
  final Forms forms;

  const FormsWidget(this.forms);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _spoiler(this.forms.yo),
        const SizedBox(height: 20),
        _spoiler(this.forms.tu),
        const SizedBox(height: 20),
        _spoiler(this.forms.el_ella_usted),
      ]),
      const SizedBox(width: 40),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _spoiler(this.forms.nosotros),
        const SizedBox(height: 20),
        _spoiler(this.forms.vosotros),
        const SizedBox(height: 20),
        _spoiler(this.forms.ellos_ustedes),
      ]),
    ]);
  }

  Widget _spoiler(String text) {
    return RepaintBoundary(child: SpoilerTextWidget(
      enable: true,
      maxParticleSize: 1.2,
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
