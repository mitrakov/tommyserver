import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommykcal/json/product.dart';
import 'package:tommykcal/model.dart';
import 'package:tommykcal/tommylogger.dart';

class NewProductWidget extends StatefulWidget { // must be Stateful
  @override
  State<NewProductWidget> createState() => _NewProductWidgetState();
}

class _NewProductWidgetState extends State<NewProductWidget> {
  final TextEditingController productCtrl     = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController kcalPer100gCtrl = TextEditingController();
  final TextEditingController defWeightCtrl   = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ElModelo>(builder: (context, child, model) =>
      Scaffold(
        appBar: AppBar(title: const Text("Añadir producto")),
        body: Padding(
          padding: const .all(8),
          child: Column(
            crossAxisAlignment: .center,
            spacing: 10,
            children: [
              TextField(
                controller: productCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Nombre del producto")
              ),
              TextField(
                controller: descriptionCtrl,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Descripción (opcional)")
              ),
              Row(
                spacing: 10,
                children: [
                  Expanded(child: TextField(
                    controller: kcalPer100gCtrl,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: .number,
                    textAlign: .center,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Kcal por 100g")
                  )),
                  Expanded(child: TextField(
                    controller: defWeightCtrl,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: .number,
                    textAlign: .center,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Peso por omisión")
                  ))
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "Enviar",
          child: const Icon(Icons.send_outlined, size: 30),
          onPressed: () => _submit(model, context),
        ),
      ),
    );
  }

  void _submit(ElModelo model, BuildContext context) async {
    if (productCtrl.text.isNotEmpty && kcalPer100gCtrl.text.isNotEmpty) {
      final description = descriptionCtrl.text.trim().isEmpty ? null : descriptionCtrl.text.trim();
      final kcal = int.tryParse(kcalPer100gCtrl.text) ?? -1;
      final weight = int.tryParse(defWeightCtrl.text);
      model.addProduct(Product(null, productCtrl.text.trim(), description, kcal, weight));
      Navigator.pop(context);
    } else TommyLogger.logger.error("Especifique los parámetros\n(producto y kcal por 100g)", 1500);
  }

  @override
  void dispose() {
    productCtrl.dispose();
    descriptionCtrl.dispose();
    kcalPer100gCtrl.dispose();
    defWeightCtrl.dispose();
    super.dispose();
  }
}
