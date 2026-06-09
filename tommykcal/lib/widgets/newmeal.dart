import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tommykcal/json/product.dart';
import 'package:tommykcal/model.dart';

class NewMealWidget extends StatefulWidget {
  final DateTime date;

  const NewMealWidget(this.date);

  @override
  State<NewMealWidget> createState() => _NewMealWidgetState();
}

class _NewMealWidgetState extends State<NewMealWidget> {
  final TextEditingController productCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  final TextEditingController commentCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ElModelo>(builder: (context, child, model) {
      return Scaffold(
        appBar: AppBar(title: const Text("Tommy Kcal")),
        body: FutureBuilder(future: model.products, builder: (context, snapshot) {
          if (snapshot.hasError) return Text("ERROR: ${snapshot.error}");
          if (!snapshot.hasData) return const Text("ERROR: No se encontró esquema");

          final productNames = snapshot.data!.map((e) => e.name);
          final product = snapshot.data!.firstWhere((p) => p.name == productCtrl.text, orElse: () => Product.empty);
          return Padding(
            padding: const EdgeInsetsGeometry.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                TypeAheadField<String>(
                  controller: productCtrl,
                  builder: (context, ctrl, focusNode) => TextField(
                    controller: ctrl,
                    focusNode: focusNode, 
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Nombre de la comida")
                  ),
                  suggestionsCallback: (prefix) {
                    final list = List<String>.from(productNames);
                    list.retainWhere((s) => s.toLowerCase().contains(prefix.toLowerCase()));
                    return list;
                  },
                  itemBuilder: (context, suggestion) => ListTile(title: Text(suggestion)),
                  onSelected: (newValue) => setState(() {
                    productCtrl.text = newValue;
                  }),
                  hideOnEmpty: true,
                ),
                Text(product.id != null ? "${product.description} (${product.kcalPer100g} kcal/100g)" : ""),
                SizedBox(
                  width: 160,
                  child: TextField(
                    controller: weightCtrl,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Peso de la comida")
                  ),
                ),
                TextField(
                  controller: commentCtrl,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Comentario")
                ),
              ],
            ),
          );
        }),
        floatingActionButton: FloatingActionButton(
          tooltip: "Enviar",
          child: const Icon(Icons.send_rounded, size: 30),
          onPressed: () => _submit(model),
        ),
      );
    });
  }

  @override
  void dispose() {
    productCtrl.dispose();
    weightCtrl.dispose();
    commentCtrl.dispose();
    super.dispose();
  }

  void _submit(ElModelo model) async {
    if (productCtrl.text.isNotEmpty && weightCtrl.text.isNotEmpty) {
      final weight = int.tryParse(weightCtrl.text) ?? -1;
      final id = (await model.products).firstWhere((p) => p.name == productCtrl.text, orElse: () => Product.empty).id;
      final comment = commentCtrl.text.isNotEmpty ? commentCtrl.text : null;
      if (id != null) {
        model.addForDate(widget.date, id, weight, comment);
        Navigator.pop(context);
      }
    } else ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Especifique los parámetros"), duration: Duration(seconds: 1))
    );
  }
}
