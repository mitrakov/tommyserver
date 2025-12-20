// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:spoiler_widget/models/text_spoiler_configs.dart';
import 'package:spoiler_widget/spoiler_text_widget.dart';
import 'package:tommylingo/json/forms.dart';
import 'package:tommylingo/widgets/trix_container.dart';

class FormsWidget extends StatelessWidget {
  final Forms forms;
  final String header;

  const FormsWidget(this.forms, this.header);

  @override
  Widget build(BuildContext context) {
    return TrixContainer(
      child: Column(children: [
        Text(header, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), // e.g. "Presente indicativo"
        const SizedBox(height: 10),
        TrixContainer(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _spoiler(forms.yo),
              const SizedBox(height: 20),
              _spoiler(forms.tu),
              const SizedBox(height: 20),
              _spoiler(forms.el_ella_usted),
            ]),
            const SizedBox(width: 50),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _spoiler(forms.nosotros),
              const SizedBox(height: 20),
              _spoiler(forms.vosotros),
              const SizedBox(height: 20),
              _spoiler(forms.ellos_ustedes),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _spoiler(String text) {
    return RepaintBoundary(child: SpoilerText(
      text: text,
      config: TextSpoilerConfig(
        isEnabled: true,
        enableFadeAnimation: true,
        enableGestureReveal: true,
        textStyle: TextStyle(fontSize: 16, color: Colors.black),
      ),
    ));
  }
}
